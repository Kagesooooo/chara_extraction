begin
  filenum = ARGV.size # "*_allres.txt"をコマンドライン引数とする
  hash = Hash::new
  array = Array.new
  array2 = Array.new
  person_nlist = Array.new
  filename = Array.new
  vec = Array.new
  val_ar = Array.new
  val = Array.new
  up = Array.new
  ok = 0 # 分類成功した犯人数
  ng = 0 # 犯人に分類された犯人以外の人物数
  sei = 0 # 犯人に分類された事例数
  sum = 0
  correct = 0 # 総犯人数
  person = 0 # 総人物数
  place = 0
  allcul = 0
  for i in 0..filenum-1
      
      # 平均正答率，総犯人数を調べる
      lineno = 0
      hash.clear
      array2.clear
      filename = ARGV[i].split("allres.txt")
      cul = 0
      File.open(ARGV[i]){|f|
          f.each_line{|line|
              lineno = lineno + 1
              if lineno == 2 then
                  array = line.split(" ")
                  array[2] = array[2].delete("%").to_f
                  sum = sum + array[2]
              end
              if lineno > 3 then
                array = line.split(" ")
                num = array[0].to_i
                num = num - 1
                hash[num] = array[45].to_f
                array2 << line
              end
              if line.include?("+1") == true then
                  cul = cul + 1
              end
          }
      }
      h = hash.sort_by{|k,v| -v}
      
      # 評価結果から，犯人分類の精度，再現率を調べる
      out_file = filename[0] + "sortres.txt"
      size = array2.size
      linenum = 0
      flag = 0
      person_n = 0
      oknum = 0
      #File.open(out_file,"a") do |io|
          h.each{|key,value|
              linenum = linenum + 1
              person = person + 1
              person_n = person_n + 1
              if flag == 0 then
                up << array2[key.to_i]
              end
              io.print linenum,":  ",array2[key.to_i]
              if array2[key.to_i].include?(" 1 -1")== true then
                ng = ng + 1
                sei = sei + 1
              end
              if array2[key.to_i].include?("+1") == true then
                  correct = correct + 1
                  if array2[key.to_i].include?(" 1 +1") == true  then
                      ok = ok + 1
                      sei = sei + 1
                      oknum = oknum + 1
                      if oknum == cul then
                          allcul = allcul + 1
                      end
                  end
                  flag = 1
                  place = place + linenum
            end
          }
      #end
      person_nlist << person_n
  end
  
  # 結果出力
  person_nlist.sort!
  size = val.size
  acc = sum / filenum
  t = allcul.to_f / 100.0
  ratio = ok.to_f / correct.to_f
  ratio2 = ok.to_f / sei.to_f
  print "correct:",correct,"\n"
  print "ok:",ok,"\n"
  print "ng:",ng,"\n"
  print "person:",person,"\n"
  print "sei:",sei,"\n"
  print "再現率:",ratio,"\n"
  print "精度:",ratio2,"\n"
  print "正答率:",acc,"\n"
  print "T精度:",t,"\n"
  ave = place.to_f / filenum
  print "平均順位：",ave,"\n"
end