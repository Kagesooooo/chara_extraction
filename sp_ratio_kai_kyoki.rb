# -*- coding utf-8 -*-

begin
    filenum = ARGV.size
    array = Array.new
    file = Array.new
    hash = Hash::new
    hash2 = Hash::new
    array2 = Array.new
    array3 = Array.new
    array4 = Array.new
    rank = Array.new
    count = Array.new
    name_r = Array.new
    sennum = 0
    name_num = 0
    for i in 0..filenum-1
        puts ARGV[i]
        num = 0
        file = ARGV[i].split("c.txt")
        top = file[0] + "_res.txt"
        linenum = 0
        linenum2 = 0
        rank.clear
        File.open(top){|f|
            f.each_line{|line|
                linenum = linenum + 1
                if linenum < 11 then
                    linenum2 = linenum2 + 1
                    name_r = line.split(" ")
                    rank << name_r[0]
                    count << name_r[1].to_i
                end
            }
        }
        for j in 0..linenum2-2
            for k in j+1..linenum2-1
                name_k = rank[j] + "&" + rank[k]
                hash[name_k] = 0
                number = count[j] + count[k]
                hash2[name_k] = number
            end
        end
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
        sent = ""
        line_no = 0
        ln = 0
        File.open(ARGV[i]){|f|
            f.each_line{|line|
              num = num + 1
              ln = ln + 1
=begin
              if ln%4 == 3 then
                sent = sent + line
              else
=end
                sent = sent + line
                openfile = file[0] + "sentence" + num.to_s + ".txt"
                File.open(openfile,"a") do |io|
                    io.print sent
                end
                sent = ""
                res = file[0] + "_allj.txt"
                txt = "| juman < " + openfile + " > " + res
                fh = open(txt)
                while !fh.eof
                    print fh.gets
                end
                fh.close
                p = 0
                up = 0
                box = num.to_s
                File.open(res){|f2|
                    f2.each_line{|line2|
                        line_no = line_no + 1
                        str = line2
                        array3 = str.split(" ")
                        if p != 1 then
                            if array3[0] != "@" then
                                if array3[5] == "人名" then
                                    for j in 0..9
                                        if array3[0] == rank[j] then
                                            box = box + ":" + array3[0]
                                            p = 1
                                            up = up + 1
                                        end
                                    end
                                end
                            elsif array3[6] == "人名" then
                                for j in 0..9
                                    if array3[1] == rank[j] then
                                        box = box + ":" + array3[1]
                                        p = 1
                                        up = up + 1
                                    end
                                end
                            end
                        else
                            p = 0
                        end
                    }
                }
                if up > 1 then
                    #puts box
                    array2 << box
                end
                txt = "| rm " + res + " " + openfile
                fh = open(txt)
                while !fh.eof
                    print fh.gets
                end
                fh.close
                #end
            }
        }
        size = array2.size
        for j in 0..size-1
            array3 = array2[j].split(":")
            size_k = array3.size
            for k in 1..size_k-2
                for l in k+1 ..size_k-1
                    if array3[k] != array3[l] and array3[l] != "@" then
                        name_k = array3[k] + "&" + array3[l]
                        name_k2 = array3[l] + "&" + array3[k]
                        if hash[name_k2].nil? == true  then
                            hash[name_k] = hash[name_k] + 1
                        else
                            hash[name_k2] = hash[name_k2] + 1
                        end
                    end
                end
            end
        end
        o_name = file[0] + "_kyoki.txt"
        File.open(o_name,"a") do |io|
            hash.each{|key,value|
                ratio = value.to_f / hash2[key].to_f * 100
                io.print key,":",value,":",ratio,"\n"
            }
        end
        array3.clear
        array4.clear
        hash.clear
    end
end

