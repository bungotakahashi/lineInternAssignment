while true #正常終了するまで繰り返し
	pid = Process.spawn("ruby getEnglishWords.rb sorted2.txt")
	puts "waiting"
	Process.waitpid(pid)
	if $?.exitstatus == 1
		next
	else
		break
	end
end
