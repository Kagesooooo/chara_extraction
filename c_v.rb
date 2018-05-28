begin
    filenum = ARGV.size # "*_20vec.txt"をコマンドライン引数とする
    array = Array.new
    box = Array.new
    out = Array.new
    outk = Array.new
    ans = Array.new
    dist = Array.new
    correct = Array.new
    array2 = Array.new
    box2 = Array.new
    hash = Hash::new
    check = Array.new
    check_dis = Array.new
    weight = Array.new
    vec = Array.new
    acc = " "
    vecnum = 21 # 次元数に応じて変更する
    for i in 0..filenum-1
        dist.clear
        weight.clear
        ans.clear
        correct.clear
        out = ARGV[i].split("_20vec.txt")
        outname = out[0] + "_20vecdet.txt"
        sum = 0
        c = 0
        d = 0
        
        # 対象小説以外の小説のデータを1つにまとめる（学習データの作成）
        pipe = ""
        for j in 0..filenum-1
            if ARGV[j].include?(out[0]) == false then
                pipe = pipe + " " + ARGV[j]
            end
        end
        pdata = "exc" + out[0] + "det.txt"
        txt = "| cat " + pipe + " > " + pdata
        fh = open(txt)
        while !fh.eof
            print fh.gets
        end
        fh.close
        txt = "| ./svm-train -t 1 " +  pdata
        fh = open(txt)
        while !fh.eof
            print fh.gets
        end
        fh.close
        model = pdata + ".model"
        result = out[0] + "_allres.txt"
        lineno = 0
        for p in 1..vecnum
            hash[p.to_s] = 0
        end
        flag = 0
        
        # モデルファイルから、係数ベクトルの計算
        File.open(model){|f|
            f.each_line{|line|
                lineno = lineno + 1
                if flag == 1 then
                    array2 = line.split(" ")
                    size = array2.size
                    for q in 1..vecnum
                        box2 = array2[q].split(":")
                        box2[1] = box2[1].to_f
                        hash[box2[0]] = hash[box2[0]] + array2[0].to_f * box2[1]
                    end
                end
                if line == "SV\n" then
                    flag = 1
                end
            }
        }
        for p in 1..vecnum
          weight << hash[p.to_s]
        end
        vec.clear
        
        # 評価データと係数ベクトルから、各人物の分離平面からの距離を計算
        File.open(ARGV[i]){|f|
            puts ARGV[i]
            f.each_line{|line|
                sum = 0
                array = line.split(" ")
                correct << array[0]
                check << array[0]
                vec << line.chomp
                size = array.size
                for j in 1..size-1
                    box = array[j].split(":")
                    box[1] = box[1].to_f
                    sum = sum + box[1] * weight[j-1].to_f
                end
                dist << sum
                check_dis << sum
            }
        }
        
        # 対象小説の評価
        outfile = out[0] + "_outres.txt"
        accfile = out[0] + "_accres.txt"
        txt = "| ./svm-predict " + ARGV[i] + " " + model + " " + outfile + " > " +accfile
        fh = open(txt)
        while !fh.eof
            print fh.gets
        end
        fh.close
        File.open(outfile){|outfile|
            outfile.each_line{|line|
                ans << line.chomp
            }
        }
        File.open(accfile){|accfile|
            accfile.each_line{|line|
                acc = line
            }
        }
        sizeans = ans.size
        
        # 結果ファイルに評価結果を出力
        File.open(result,"a") do |io|
            io.print "結果 正答 ベクトル 距離\n"
            io.puts acc
            wsize = weight.size
            io.print "係数vec:",weight[0]
            for m in 1..wsize-1
                io.print ",",weight[m]
            end
            io.print "\n"
            for m in 0..sizeans-1
                io.print m+1," ",ans[m]," ",vec[m]," ",dist[m],"\n"
            end
        end
        
        # 不要なファイルの削除
        txt = "| rm " + outfile + " " + accfile + " " + model + " " + pdata
        fh = open(txt)
        while !fh.eof
            print fh.gets
        end
        fh.close
    end
end