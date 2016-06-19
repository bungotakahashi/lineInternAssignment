# encoding: utf-8
require "./deleteDuplicates.rb"
FileName = "sorted"

def sort(fname)
	f=open(ARGV[0], "r:UTF-8") #ARGV[0]=filename
	f2=open(fname+".txt", "w:UTF-8")
	data=Array.new
	f.each do |line|
		data.push(line.encode("Shift_JIS", :invalid => :replace, :undef => :replace)) #日本語(UTF-8)を配列に入れると文字化け。SJISで回避。
	end

	neededSpeech=["名詞", "動詞", "形容詞"] #必要な品詞選択。助詞などは英語に翻訳不可。

	data.sort!.each do |line|
		unless line.encode("UTF-8")==nil
			word=line.encode("UTF-8").split("\t")[0]
			meta=line.encode("UTF-8").split("\t")[1]
			unless meta==nil
				speechType=meta.split(",")[0]
				if neededSpeech.include?(speechType)
					if meta.split(",")[1]=="数" || word.match(/.*[!-z].*/)
						next
					end
					f2.puts line.encode("UTF-8") #SJISの状態であるので,UTF-8に戻す。
				end
			end
		end

	end
	f.close
	f2.close
end

sort(FileName)
deleteDup(FileName)