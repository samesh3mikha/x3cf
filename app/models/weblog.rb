# require 'alchemy_api'

class Weblog < ActiveRecord::Base
  attr_accessible :url, :title, :visited_at, :source, :porn, :source_id

  belongs_to :user  
  
  class << self
    def checkIfPorn(url)
      puts ('++++++++++++++++++++++++++++++ CHECKING IF PORN')
      
      #FETCH CF LINE ... NOT RETURNING LINE OBJECT AS EXPECTED BY CF SO KEPT ON HOLD
      # line = CF::Line.info("auto-adult-content-moderation-line")
      # puts ('++++++++++++++++++++++++++++++++++++++++++  LINE')
      # puts (line.inspect)

      #CREATE RUN
      run = CF::Run.create("auto-adult-content-moderation-line", "x3cf_11",  [{"url" => "http://sexstory.com/index.htm", "meta_data" => "http://sexstory.com"},{"url" => "http://googe.com", "meta_data" => "http://googe.com"}, {"url" => "http://gogle.com", "meta_data" => "http://googe.com"}])
      puts ('++++++++++++++++++++++++++++++++++++++++++  RUN')
      puts (run.inspect)
            
      # FETCH OUTPUT
      final_output = run.final_output #CF::Run.final_output("x3cf_1")
      puts ('++++++++++++++++++++++++++++++++++++++++++  FINAL output')
      puts (final_output.inspect)
      
      return false
    end
  
    def match_badwords(content)
      keywords_hash = Hash.new
      keywords = APP_CONFIG['keywords']      

      keywords.each do |keyword|
        if content.include?(keyword)
           keywords_hash.keys << keyword
           keywords_hash[keyword] = content.scan(/#{keyword}/i).count
        end
      end
    
      return keywords_hash
    end
  end
    
end