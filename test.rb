def name_extraction
    #　人物名抽出
    # filename = $res
    filename = "jumann.txt"
    print("人物名出力ファイル名:")
    $outname = gets.chomp
    array = Array.new
    str = ""
    File.open(filename){|f|
        f.each_line{|line|
            # if /PERSON:[あ-ん一-龠ア-ンー]+/ =~ line then
            #     line.scan(/PERSON:[あ-ん一-龠ア-ンー]+/){|st|
            #         size = st.size
            #         if size == 8 and /[あ-んア-ンー]/ =~ st then
            #             str = ""
            #             elsif size > 8 and /[あ-んア−ン]+/ =~ st then
            #             str = ""
            #             else
            #             for i in 7..size-1
            #                 str = str+st[i]
            #             end
            #             puts str
            #             array << str
            #             str = ""
            #         end
            #     }
            # end
            if /PERSON:(.*?)><照応詞候補/ =~ line then
              str = line.scan(/PERSON:(.*?)>/)
              array << str.join
              str = ""
            end
        }
    }
    newary = array.uniq
    size = newary.size
    newary.each{|var|
        File.open($outname,"a") do |io|
            io.print var,"\n"
        end
    }
end


def pronoun_conv
    #　代名詞変換
    # filename = $res
    # origin = $eliminate3
    # person = $outname

    filename = "jumann.txt"
    origin = "sep_sen2.txt"
    person = "hito.txt"

    print("代名詞変換ファイル:")
    out = gets.chomp
    array3 = Array.new
    persons = Array.new
    before = Array.new
    after = Array.new
    convert = Array.new
    eid_word = Array.new
    i = 0
    str = ""
    str2 = ""
    judge = 0
    num = ""
    File.open(origin){|f|
        f.each_line{|line|
            array3 << line
        }
    }
    File.open(person){|f|
        f.each_line{|line|
            name = line.chomp
            persons << name
        }
    }
    size = array3.size
    File.open(filename){|f|
        f.each_line{|line|
            if line.include?("%% LABEL") == true then
                line.scan(/=\d+/){|no|
                    size = no.size
                    for k in 1..size-1
                        num = num + no[k]
                    end
                    i = num.to_i
                    i = i - 1
                    num = ""
                }
            end
            line.scan(/EID:\d+/){|eid|
                eid2 = ""
                size = eid.size
                for k in 4..size-1
                    eid2 = eid2 + eid[k]
                end
                eidnum = eid2.to_i
                line.scan(/正規化代表表記:[あ-ん一-龠ア-ンー々]+/){|word|
                    words = ""
                    size = word.size
                    for p in 8..size-1
                        words = words + word[p]
                    end
                    if eid_word[eidnum] == nil then
                        eid_word[eidnum] = words
                    end
                }
            }
            if line.include?("照応詞候補:") == true and line.include?("C用;") == true then
                line.scan(/照応詞候補:[あ-ん一-龠ア-ンー々]+/){|st|
                    size = st.size
                    for j in 6..size-1
                        str = str + st[j]
                    end
                }
                line.scan(/C用;【[あ-ん一-龠ア-ンー々]+】/){|st2|
                    size2 = st2.size-1
                    for j in 4..size2-1
                        str2 = str2 + st2[j]
                    end
                }
                psize = persons.size
                for k in 0..psize-1
                    if str.include?(persons[k]) == true then
                        judge = 1
                    end
                end
                if judge != 1 then
                    if str.include?(str2) == false then
                        box1 = str
                        box2 = str2
                        else
                        box1 = str
                        line.scan(/EID:\d+/){|eid|
                            eid2 = ""
                            size = eid.size
                            for k in 4..size-1
                                eid2 = eid2 + eid[k]
                            end
                            eidnum = eid2.to_i
                            box2 = eid_word[eidnum]
                        }
                    end
                    before[i] = box1
                    after[i] = box2
                    if before[i].nil? == false and after[i].nil? == false then
                        print before[i],"  .  ",after[i],"\n"
                        len = before[i].length
                        pos = array3[i].index(before[i])
                        str = array3[i]
                        str[pos,len] = after[i]
                        array3[i] = str
                    end
                    before[i] = ""
                    after[i] = ""
                end
                str = ""
                str2 = ""
                judge = 0
            end
        }
    }

    size = array3.size
    File.open(out,"a") do |io|
        for i in 0..size-1
            io.print array3[i]
        end
    end
end


begin
  # name_extraction
  pronoun_conv
end
