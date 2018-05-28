begin
    print("統合ファイル1:")
    file1 = gets.chomp
    print("統合ファイル2:")
    file2 = gets.chomp
    print("結果ファイル:")
    file_res = gets.chomp
    array = Array.new
    File.open(file1){|f|
        f.each_line{|line|
            if line.include?("見出し語") == true then
                array << line
            end
        }
    }
    File.open(file2){|f|
        f.each_line{|line|
            if line.include?("見出し語") == true then
                array << line
            end
        }
    }
    size = array.size
    File.open(file_res,"a") do |io|
        io.print "(名詞 (人名\n"
        for i in 0..size-1
            io.print array[i]
        end
        io.print "))\n"
    end
end
    