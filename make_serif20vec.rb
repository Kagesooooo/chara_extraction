begin
    filenum = ARGV.size
    array = Array.new
    array2 = Array.new
    array3 = Array.new
    name = Array.new
    vec_all = Array.new
    vec = Array.new
    hash = Hash::new
    hash_serif = Hash::new
    cul = Array.new
    det = Array.new
    hash2 = Hash::new
    hash3 = Hash::new
    hash2_serif = Hash::new
    hash3_serif = Hash::new
    cul_add = Array.new
    det_add = Array.new
    detcul = Array.new
    for i in 0..filenum-1
        name.clear
        lineno = 0
        array = ARGV[i].split("serif.txt")
        serif_f = array[0] + "serif.txt"
        lineno = 0
        File.open(serif_f){|f|
            f.each_line{|line|
                lineno = lineno + 1
                array2 = line.split(" ")
                hash_serif[array2[0]] = 100.0 / array2[1].to_i
                #if array2[2].delete("%").to_f > 1.0 then
                name << array2[0]
                hash2_serif[array2[0]] = array2[2].delete("%")
                hash3_serif[array2[0]] = lineno.to_s
                #end
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
              #print name[k],":",cul_add[g],"\n"
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
              open_file = array[0] + "_result_serif" + j.to_s + ".txt"
              #print open_file + " " + name[k] + "\n"
              puts lineno
              File.open(open_file){|f|
                  f.each_line{|line|
                      array3 = line.split(" ")
                      if name[k].include?(array3[0]) == true or array3[0].include?(name[k]) == true then
                          lineno = lineno + 1
                          num = array3[2].delete("%\n")
                          num = num.to_f
                          vec << lineno.to_s + ":" + num.to_s + " "
                          per = array3[1].to_i * hash_serif[name[k]]
                          lineno = lineno + 1
                          vec << lineno.to_s + ":" + per.to_s + " "
                          flag = 1
                          puts lineno
                      end
                  }
              }
              if flag == 0 then
                  lineno = lineno + 1
                  vec << lineno.to_s + ":" + "0.00 "
                  lineno = lineno + 1
                  vec << lineno.to_s + ":" + "0.00 "
                  puts lineno
              end
          end
          vector = ""
          vec_size = vec.size
          for r in 0..vec_size-1
            vector = vector + vec[r]
            puts vector
          end
          puts vector
          lineno = lineno + 1
          if hash2_serif[name[k]].nil? == false then
            last = lineno.to_s + ":" + hash2_serif[name[k]] + " "
            vector = vector + last
            lineno = lineno + 1
            last = lineno.to_s + ":" + hash3_serif[name[k]]
            vector = vector + last
          else
            last = lineno.to_s + ":" + "0.00 "
            vector = vector + last
            lineno = lineno + 1
            last = lineno.to_s + ":" + "0.00 "
            vector = vector + last
          end
          vec_all << vector
          vec.clear
          vector = ""
        end
        vec_file = array[0] + "_20vec.txt"
        File.open(vec_file,"a") do |io|
            size = vec_all.size
            #puts size
            for j in 0..size-1
                io.print vec_all[j],"\n"
            end
        end
        vec_all.clear
    end
end
        
