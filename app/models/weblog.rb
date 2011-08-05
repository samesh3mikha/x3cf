# require 'alchemy_api'

class Weblog < ActiveRecord::Base
  attr_accessible :url, :title, :visited_at, :source, :porn, :source_id

  belongs_to :user  
  
  class << self
    def checkIfPorn(url)
      puts ('++++++++++++++++++++++++++++++ CHECKING IF PORN')
      
        title = AlchemyApi::TextExtraction.get_title_from_url(url).title
        title = title.downcase
        total_title_words = title.split.size
        badwords_hash = Hash.new
        badwords_hash = match_badwords(title)
        badwords_count = 0
        badwords_percent = 0
        badwords_hash.values.each do |value|
          badwords_count += value
        end
        puts ('++++++++++++++++++++++++++++++ TITLE PARSING')
        puts (badwords_hash)

        if total_title_words > 0
          badwords_percent = (badwords_count/total_title_words) * 100
        end
        if badwords_percent >= 25
          return true
        end
                                    
        content = AlchemyApi::TextExtraction.get_raw_text_from_url(url).text
        content = content.downcase
        total_content_words = content.split.size
        badwords_hash = Hash.new      
        badwords_hash = match_badwords(content)
        badwords_count = 0
        badwords_percent = 0
        badwords_hash.values.each do |value|
          badwords_count += value
        end
        puts ('++++++++++++++++++++++++++++++ CONTENT PARSING')
        puts (url)
        puts (content)
        puts (badwords_hash)

        if total_content_words > 0
          badwords_percent = (badwords_count/total_content_words) * 100
        end      
        if badwords_count >= 35 or badwords_percent >= 25
          return true
        end
      
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