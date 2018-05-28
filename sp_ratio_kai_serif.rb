# -*- coding utf-8 -*-

begin
    filenum = ARGV.size
    array = Array.new
    file = Array.new
    hash = Hash::new
    hash_b = Hash::new
    array2 = Array.new
    array3 = Array.new
    sennum = 0
    name_num = 0
    for i in 0..filenum-1
        array2.clear
        array3.clear
        txt = "| wc -l " + ARGV[i] + " > sen.txt"
        fh = open(txt)
        while !fh.eof
            print fh.gets
        end
        fh.close
        senbox = Array.new
        File.open("sen.txt"){|sen|
            sen.each_line{|senline|
                senbox = senline.split(" ")
                sennum = senbox[0]
            }
        }
        allsen = sennum.to_i
        sum = 0
        line_no = 0
        file = ARGV[i].split("c.txt")
        res = file[0] + "_allj.txt"
        txt = "| juman < " + ARGV[i] + " > " + res
        fh = open(txt)
        while !fh.eof
            print fh.gets
        end
        fh.close
        p = 0
        serif = 0
        File.open(res){|f|
            f.each_line{|line|
                line_no = line_no + 1
                str = line
                array3 = str.split(" ")
                if line.include?("「 「 「") == true then
                    serif = 1
                    elsif line.include?("」 」 」") == true then
                    serif = 0
                end
                if p != 1 and serif == 1 then
                    if array3[0] != "@" then
                        if array3[5] == "人名" then
                            array2 << array3[0]
                            hash[array3[0]] = 0
                            p = 1
                        end
                        else
                        if array3[6] == "人名" then
                            array2 << array3[1]
                            hash[array3[1]] = 0
                        end
                    end
                    else
                    p = 0
                end
            }
        }
        k = array2.size
        for j in 0..k-1
            hash[array2[j]] = hash[array2[j]] + 1
        end
        m = 0
        trash = Array.new
        hash.each{|key,value|
            hash.each{|key2,value2|
                if key.include?(key2) == true and key != key2 then
                    value = value + value2
                    hash[key] = value
                    trash << key2
                end
            }
        }
        size = trash.size
        for p in 0..size-1
            hash.delete(trash[p])
        end
        keyar = Array.new
        valuear = Array.new
        sumall = 0
        hash_b.each{|key,value|
            sumall = sumall + value
        }
        h = hash.sort_by{|k,v| -v}
        name_file = file[0] + "_name.txt"
        name_num = 0
        File.open(name_file,"a") do |io|
          h.each{|key,value|
              ratio = value.to_f / sumall.to_f
              io.print key," ",value," ",ratio,"\n"
              keyar << key
              name_num = name_num + 1
          }
        end
        print ARGV[i],":",name_num,"\n"
        sizekey = keyar.size
#--元ファイルから人名カウント完了--
        for j in 0..9
            array2.clear
            array3.clear
            hash_b.clear
            line_no = 0
            linenum = 0
            out = file[0] + "_c" + j.to_s + ".txt"
            File.open(ARGV[i]){|f|
                f.each_line{|line|
                    linenum = linenum + 1
                    if (linenum > allsen / 10 * j) and (linenum <= allsen / 10 * (j + 1)) then
                        File.open(out,"a") do |io|
                            io.print line
                        end
                    end
                }
            }
            linenum = 0
            jname = file[0] + "j" + j.to_s + ".txt"
            txt = "| juman < " + out + " > " + jname
            fh = open(txt)
            while !fh.eof
                print fh.gets
            end
            fh.close
            serif = 0
            p = 0
            File.open(jname){|f|
                f.each_line{|line|
                    line_no = line_no + 1
                    str = line
                    array3 = str.split(" ")
                    if line.include?("「 「 「") == true then
                        serif = 1
                    elsif line.include?("」 」 」") == true then
                        serif = 0
                    end
                    
                    if p != 1 and serif == 1 then
                        if array3[0] != "@" then
                            if array3[5] == "人名" then
                                array2 << array3[0]
                                hash_b[array3[0]] = 0
                                p = 1
                            end
                            else
                            if array3[6] == "人名" then
                                array2 << array3[1]
                                hash_b[array3[1]] = 0
                            end
                        end
                        else
                        p = 0
                    end
                }
            }
            k = array2.size
            for n in 0..k-1
                hash_b[array2[n]] = hash_b[array2[n]] + 1
            end
            m = 0
            trash.clear
            hash_b.each{|key,value|
                hash_b.each{|key2,value2|
                    if key.include?(key2) == true and key != key2 then
                        value = value + value2
                        hash_b[key] = value
                        trash << key2
                    end
                }
            }
            size = trash.size
            for p in 0..size-1
                hash_b.delete(trash[p])
            end
            sum = 0
            hash_b.each{|key,value|
                sum = sum + value
            }
            size = hash.size
            out_file = file[0] + "_result_serif" + j.to_s + ".txt"
            h = hash_b.sort_by{|k,v| -v}
            flag = 0
            h.each{|key,value|
                File.open(out_file,"a") do |io|
                    for d in 0..sizekey-1
                        if key == keyar[d] then
                            ratio = value.to_f / sum.to_f * 100.0
                            io.print key," ",value," ",ratio,"%\n"
                            flag = 1
                        end
                    end
                end
            }
            if flag == 0 then
                File.open(out_file,"a") do |io|
                    io.print "nothing\n"
                end
            end
             txt = "| rm " + jname + " " + out
             fh = open(txt)
             while !fh.eof
               print fh.gets
             end
             fh.close
        end
        valuear.clear
        keyar.clear
        hash.clear
         txt = "| rm " + res
         fh = open(txt)
         while !fh.eof
         print fh.gets
         end
         fh.close
    end
end

