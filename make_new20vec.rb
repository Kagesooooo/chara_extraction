begin
    filenum = ARGV.size
    array = Array.new
    array2 = Array.new
    array3 = Array.new
    name = Array.new
    vec_all = Array.new
    vec = Array.new
    hash = Hash::new
    cul = Array.new
    det = Array.new
    cul_add = Array.new
    det_add = Array.new
    detcul = Array.new
    for i in 0..filenum-1
        name.clear
        array = ARGV[i].split("_name.txt")
        File.open(ARGV[i]){|f|
            f.each_line{|line|
                array2 = line.split(" ")
                hash[array2[0]] = 100.0 / array2[1].to_i
                if array2[2].delete("%").to_f > 1.0 then
                  name << array2[0]
                end
            }
        }
        name_size = name.size
        dc_file = array[0] + "_vec.txt"
        lineno = 0
        det.clear
        cul.clear
        File.open(dc_file){|f|
            f.each_line{|line|
                if lineno == 0 then
                    detcul = line.split(",")
                end
                lineno = lineno + 1
            }
        }
        cul = detcul[0].split(":")
        csize = cul.size
        cul_add.clear
        det_add.clear
        for m in 1..csize-1
            cul_add << cul[m]
        end
        det = detcul[1].split(":")
        dsize = det.size
        for m in 1..dsize-1
            det_add << det[m]
        end
        adsize = cul_add.size
        for k in 0..name_size-1
          flag2 = 0
          for g in 0..adsize-1
            print name[k],":",cul_add[g],"\n"
            if name[k].include?(cul_add[g].chomp) == true or cul_add[g].chomp.include?(name[k]) == true then
                vec << "+1 "
                flag2 = 1
            end
          end
          if flag2 == 0 then
              vec << "-1 "
          end
          lineno = 0
          for j in 0..9
              flag = 0
              open_file = array[0] + "_result" + j.to_s + ".txt"
              print open_file + " " + name[k] + "\n"
              File.open(open_file){|f|
                  f.each_line{|line|
                      array3 = line.split(" ")
                      if name[k].include?(array3[0]) == true or array3[0].include?(name[k]) == true then
                          lineno = lineno + 1
                          vec << lineno.to_s + ":" + array3[2].delete("%\n") + " "
                          per = array3[1].to_i * hash[name[k]]
                          lineno = lineno + 1
                          vec << lineno.to_s + ":" + per.to_s + " "
                          flag = 1
                      end
                  }
              }
              if flag == 0 then
                  lineno = lineno + 1
                  vec << lineno.to_s + ":" + "0.00 "
                  lineno = lineno + 1
                  vec << lineno.to_s + ":" + "0.00 "
              end
              vec_size = vec.size
              vector = ""
              for r in 0..vec_size-1
                  vector = vector + vec[r]
              end
              puts vector
          end
          vec_all << vector
          vec.clear
          vector = ""
        end
        vec_file = array[0] + "_20vec.txt"
        File.open(vec_file,"a") do |io|
            size = vec_all.size
            puts size
            for j in 0..size-1
                io.print vec_all[j],"\n"
            end
        end
        vec_all.clear
    end
end
        