# require 'alchemy_api'

class Weblog < ActiveRecord::Base
  attr_accessible :url, :title, :visited_at, :source, :porn, :source_id

  belongs_to :user  
  
  class << self
    def checkIfPorn(url)
      puts ('++++++++++++++++++++++++++++++ CHECKING IF PORN')
      
      #FETCH CF LINE
      line = CF::Line.info("auto-adult-content-moderation-line")
      
      #CREATE RUN
      run = CF::Run.create(line, "x3cf_1", ["http://google.com","http://msn.com","http://yahoo.com"])
      
      # FETCH OUTPUT
      final_output = Run.final_output("x3cf_1")
      
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