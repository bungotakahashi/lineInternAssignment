# encoding: utf-8
require 'nokogiri'
require 'anemone'
require 'uri'
require 'cgi'
require 'rubygems'
OriginalUrl = "http://ejje.weblio.jp/content/"

def getEngWords(line)
  i = 0 
  url = ""
  options = {
    :storage => Anemone::Storage::SQLite3(),
    :threads => 4,
    :delay => 1,
    :depth_limit => 0
  }

  jWord = line.split("\t")[0]
  meta = line.split("\t")[1]
  type = meta.split(",")[0] #品詞
  wordForm = meta.split(",")[5] #活用形
  basicForm = meta.split(",")[6] #基本形
  if type == "名詞"
    url = OriginalUrl + CGI.escape(jWord)
  elsif wordForm == "基本形"
    url = OriginalUrl + CGI.escape(jWord)
  else
    url = OriginalUrl + CGI.escape(basicForm)
  end

  Anemone.crawl(url, options) do |anemone|
    anemone.on_every_page do |page|
      #puts "code: #{page.code}"
      #puts "url: #{page.url}"
      #puts "error: #{page.error}"

      if page.doc
        i+=1
        eWords = page.doc.xpath("//*[@id='summary']/div/table/tbody/tr/td[2]").text().to_s
        if eWords != "" && eWords != nil && !eWords.include?("Anemone::Core") 
          return "#{jWord}\t#{eWords}"
        end
      end
    end
  end

  return nil
end


f=open(ARGV[0])
f2=open("MetaEnglish.txt", "a")
f.each_with_index do |line, i|
  begin
    result = getEngWords(line)

    puts i
    puts result
    2.times do
      puts ""
    end

    if result != nil
      f2.puts result
    end
  rescue => e
    exit(1)
  end   


end  

f.close
f2.close  
