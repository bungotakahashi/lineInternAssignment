# encoding: utf-8
require 'nokogiri'
require 'anemone'
require "open3"
Count = 300000 #取得する単語数（重複含む）
def crawl()
  count = 0
  i = 0 
  f = open("data.txt", "w")

  startUrl="http://bylines.news.yahoo.co.jp/"
  options = {
    :skip_query_strings => true,
    :depth_limit => 6,
  }
  


  Anemone.crawl(startUrl, options) do |anemone| #start crawling
    anemone.on_every_page do |page|
      puts "count: #{count}"
      if count > Count 
        puts "Finished!"
        return
      end
      if page.doc
        target = page.doc.css("p").inner_html.gsub(/<(".*?"|'.*?'|[^'"])*?>/, '') #無駄なタグを取得したp要素から削除
        target.delete!("\n") #記事中の不要な改行は外部コマンド(mecab) を正しく動作させない恐れがあるので削除.
        out, error, status = Open3.capture3("echo #{target} | mecab -d /usr/local/lib/mecab/dic/mecab-ipadic-neologd")
        if out.to_s.end_with?("EOS\n") #正しく解析されればEOSがmecabから帰ってくる
          begin
            count += out.encode("UTF-8", replace: "?").count("\n") #現在の単語数を表示
            f.puts out.encode("UTF-8")
          rescue ArgumentError => e
            puts "ERROR"
            next
          end
        end
      end
    end
  end 
  f.close
end

crawl()
