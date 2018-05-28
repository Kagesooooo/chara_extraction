# -*- coding utf-8 -*-
def num_sentence(title)
    sennum = 0
    txt = "| wc -l " + title + " > sen.txt"
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
    return sennum
end

def analyze_juman1(title,file)
    res = file + "_allj.txt"
    txt = "| juman < " + title + " > " + res
    fh = open(txt)
    while !fh.eof
        print fh.gets
    end
    fh.close
    p = 0
    return res
end

def analyze_juman2(out,file,j)
    jname = file[0] + "j" + j.to_s + ".txt"
    txt = "| juman < " + out + " > " + jname
    fh = open(txt)
    while !fh.eof
        print fh.gets
    end
    fh.close
    p = 0
    return jname
end

def search_name(res)
    hash = Hash::new
    array3 = Array.new
    array2 = Array.new
    line_no = 0
    File.open(res){|f|
        f.each_line{|line|
            line_no = line_no + 1
            str = line
            array3 = str.split(" ")
            if p != 1 then
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
    return hash
end

def all_story(hash)
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
    return hash
end

def matome(hash,file)
    $keyar = Array.new
    $valuear = Array.new
    h = hash.sort_by{|k,v| -v}
    name_file = file + "_name.txt"
    name_num = 0
    File.open(name_file,"a") do |io|
        h.each{|key,value|
            io.print key," ",value,"\n"
            $keyar << key
            name_num = name_num + 1
        }
    end
    sizekey = $keyar.size
    return sizekey
end

def sep_story(title,file,j,sennum,vecnum)
    out = file + "_c" + j.to_s + ".txt"
    linenum = 0
    allsen = sennum.to_i
    File.open(title){|f|
        f.each_line{|line|
            linenum = linenum + 1
            if (linenum > allsen / vecnum * j) and (linenum <= allsen / vecnum * (j + 1)) then
                File.open(out,"a") do |io|
                    io.print line
                end
            end
        }
    }
    linenum = 0
    return out
end

def count_name(jname)
    hash_b = Hash::new
    array2 = Array.new
    array3 = Array.new
    line_no = 0
    File.open(jname){|f|
        f.each_line{|line|
            line_no = line_no + 1
            str = line
            array3 = str.split(" ")
            if p != 1 then
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
    trash = Array.new
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
    return hash_b
end

def all_chara(hash_b)
    sum = 0
    hash_b.each{|key,value|
        sum = sum + value
    }
    size = hash.size
    v = sum / size
    return sum
end

def output(hash_b,file,sum,j,sizekey,f)
    if f == 1 then
        out_file = file + "_res.txt"
    else
        out_file = file + "_result" + j.to_s + ".txt"
    end
    h = hash_b.sort_by{|k,v| -v}
    flag = 0
    h.each{|key,value|
        File.open(out_file,"a") do |io|
            for d in 0..sizekey-1
                if key == $keyar[d] then
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
end

def delete_file(jname,out)
    txt = "| rm " + jname + " " + out
    fh = open(txt)
    while !fh.eof
        print fh.gets
    end
    fh.close
end


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
    f = 1
    vecnum = 10 # 分割数を設定
    while(f < vecnum + 2)
        for i in 0..filenum-1
            file = ARGV[i].split("c.txt")
            array2.clear
            array3.clear
            sennum = num_sentence(ARGV[i])
            res = analyze_juman1(ARGV[i],file[0])
            hash = search_name(res)
            hash = all_story(hash)
            sizekey = matome(hash,file[0])
            for j in 0..f-1
                array2.clear
                array3.clear
                hash_b.clear
                line_no = 0
                linenum = 0

                out = sep_story(ARGV[i],file[0],j,sennum,f)
                jname = analyze_juman2(out,file[0],j)
                hash_b = count_name(jname)
                sum = all_chara(hash_b)
                output(hash_b,file[0],sum,j,sizekey,f)
                delete_file(jname,out)
            end
            $valuear.clear
            $keyar.clear
            hash.clear
            txt = "| rm " + res
            fh = open(txt)
            while !fh.eof
                print fh.gets
            end
            fh.close
        end
        f = f + vecnum - 1
    end
end
