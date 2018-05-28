import re
from collections import defaultdict

# j = open('juman_anaphora_tab.txt')
# s = open('sep_sen2.txt')

# １行に１文の物語テキスト
s = open('sep_sen3.txt')
# s = open('unko.txt')

# jumanpp | knp -anaphora -tab　で s を解析した結果を用いる
j = open('juman_anaphora_tab3.txt')
# j = open('unko.jumanpp')

# 加工される文
sens = s.readlines()

# 文のカウント
sen_cnt = 0

# 元の文
plane_sens = [sen for sen in sens]

# eidを格納するdict 初出かの判断で便利なのでdefaultdictを用いる
eid_dic = defaultdict(str)

# 解析結果を１行ずつみるループ
# 代名詞を変換して、ゼロ照応されてる単語を文末に置いとく処理をする
# sens[]が加工されていく
for ana in j:

    # 行数カウント
    if '# S-ID:' in ana:
        sen_cnt += 1

    # EIDが含まれていれば
    # EIDが初出か既出か判断して代名詞変換を行う
    if '<EID:' in ana:
        eid_search = re.search(r'<EID:(.*?)>',ana)
        eid = int(eid_search.group(1))

        # eidの対象の単語は正規化代表表記にあるものとする ほんまにこれでええんか
        eid_word_search = re.search(r'<正規化代表表記:(.*?)>',ana)

        # こんなことあるんか
        if eid_word_search == None:
            continue

        #初めて出てきたEIDのとき
        if eid_dic[eid] == '':
            word = eid_word_search.group(1)

            # <正規化代表表記:役目/やくめ> みたいなやつ対策 ほんまにこれでええんか
            eid_dic[eid] = word.split('/')[0]

        # 既出のEIDのとき
        # 既出ということは！！変換のチャンス！！
        # 照応詞候補を変換していく
        # もし照応詞候補がC用と違うかったら、照応詞候補をC用に変換
        # C用と同じならば、照応詞候補をeid_dicに入ってる単語（初めてそのEIDで出てきた単語）に変換
        else:
            sho_search = re.search(r'<照応詞候補:(.*?)>',ana)
            c_search = re.search(r'<C用;【(.*?)】',ana)

            # こんなことあるんか
            if sho_search == None or c_search == None:
                continue

            # わっしょい
            else:
                sho = sho_search.group(1)
                c = c_search.group(1)

                # 照応詞候補とC用が同じならば、そのEIDの初出の時の正規化代表表記の単語と置き換え
                if sho == c:
                    sens[sen_cnt-1] = sens[sen_cnt-1].replace(sho,eid_dic[eid])

                # 違うなら照応詞候補とC用と置き換え
                else:
                    sens[sen_cnt-1] = sens[sen_cnt-1].replace(sho,c)


    # ゼロ照応処理
    # ゼロ照応見つけたらとりあえず文末にspaceあけて単語置いとく



    # ガ 　文の主語やと思う
    zero_search = re.findall(r'ガ/./(.*?)/',ana)

    # ガ　がなければパス
    if zero_search == None:
            pass

    # あったとき
    else:

        zero = '-'
        i = 1
        for s in zero_search:
            if s != '-':
                zero = s
            i += 1


        # 文になければ（ゼロ照応ならば）　（'-'は無視）
        if (zero not in plane_sens[sen_cnt-1]) and (zero != '-'):

            # sens[]の文末の'\n'をstripしてspaceを追加して単語置いとく
            sens[sen_cnt-1] = zero + 'が' + sens[sen_cnt-1]

    # ヲ 　をって何ていうんや　目的語？？　それを見つけよーう
    zero_search = re.search(r'ヲ/./(.*?)/',ana)

    # なければコンちぬー
    if zero_search == None:
        continue

    # あったとき
    else:
        zero = zero_search.group(1)

        # ゼロ照応なら　文末に置いとく
        if (zero not in plane_sens[sen_cnt-1]) and (zero != '-'):
            sens[sen_cnt-1] = zero + 'を' + sens[sen_cnt-1]

for sen in sens:
    print(sen.strip())
