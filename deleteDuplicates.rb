# encoding: utf-8

def deleteDup(fname)
	f=open(fname+".txt") #ARGV[0]=filename
	f2=open(fname+"2.txt", "w:UTF-8")

	data=Array.new
	f.each do |line|
		data.push(line.encode("Shift_JIS", :invalid => :replace, :undef => :replace))
	end

	data.each_with_index do |line, i| #ソート済みのデータを検証。重複を削除。
		ok = 0
		while ok == 0 
			if line == nil || data[i+1] == nil
				ok=1
				next
			end

			word1 = line.split("\t")[0]
			word2 = data[i+1].split("\t")[0]
			if word1 == word2
				data.delete_at(i)
				redo
			else
				ok = 1
			end
		end
	end

	data.each do |line|
		f2.puts line.encode("UTF-8")
	end
	f.close
	f2.close
end