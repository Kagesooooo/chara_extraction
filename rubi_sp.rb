# -*- coding utf-8 -*-

begin
  filenum = ARGV.size
  file_n = Array.new
  for m in 0..filenum-1
#　文字コード変換
    original = ARGV[m]
    file_n = ARGV[m].split(".txt")
    nkf = file_n[0] + "x.txt"
    txt = "| nkf -w < " + original + " > " + nkf
	fh = open(txt)
	while !fh.eof
        print fh.gets
	end
	fh.close

#　ルビとりの部分
    filename = nkf
    outr = file_n[0] + "r.txt"
    conv = Array.new
    p = 0
    a = 0
    k = 0
    File.open(filename){|f|
        f.each_line{|line|
            if (p < 2 or p > 14) and k == 0 then
                if /底本：/u =~ line then
                    k = 1
                else
                    if /《[あ-ん一-龠ア-ンー]+》/ =~ line then
                        line.gsub!(/《[あ-ん一-龠ア-ンー]+》/,"")
                    elsif /［[＃あ-ん一-龠ア-ンー]+］/ =~ line then
                        line.gsub!(/［[＃あ-ん一-龠ア-ンー]+］/,"")
                    end
                    conv << line
                end
            end
            p = p + 1
        }
    }
    size = conv.size
    File.open(outr,"a") do |io|
        for i in 0..size-1
            io.print conv[i]
        end
    end

#　文区切りにする部分
    f_name = outr
    printf("文区切りファイル : ")
    o_name = file_n[0] + "sep.txt"
    array = Array.new
    File.open(f_name){|f|
        f.each_line{|line|
            str = line
            array = str.split("。")
            p = array.size
            File.open(o_name,"a") do |io|
                for i in 0..p-1
                    io.print array[i],"\n"
                end
            end
        }
    }
    
#空行削除
    eliminate3 = file_n[0] + "_noconv.txt"
    txt = "| grep -v '^\s*#' " + o_name + "| grep -v '^s*$' > " + eliminate3
    fh = open(txt)
    while !fh.eof
        print fh.gets
    end
    fh.close
    
#余計なファイル削除
    txt = "| rm " + nkf
    fh = open(txt)
    while !fh.eof
        print fh.gets
    end
    fh.close

    txt = "| rm " + outr
    fh = open(txt)
    while !fh.eof
        print fh.gets
    end
    fh.close

    txt = "| rm " + o_name
    fh = open(txt)
    while !fh.eof
        print fh.gets
    end
    fh.close
  end
end
