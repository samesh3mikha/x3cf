# require 'alchemy_api'

class Weblog < ActiveRecord::Base
  attr_accessible :url, :title, :visited_at, :source, :porn, :source_id

  belongs_to :user  
  
  class << self
    def checkIfPorn(weblogs)
      puts ('++++++++++++++++++++++++++++++ CHECKING IF PORN')
      
      #FETCH CF LINE ... NOT RETURNING LINE OBJECT AS EXPECTED BY CF SO KEPT ON HOLD
      # line = CF::Line.info("auto-adult-content-moderation-line")

      #CREATE RUN
      run_title = APP_CONFIG['run_title_prefix'] + "_" +  weblogs[0].id.to_s + "_" +  weblogs[1].id.to_s + "_" +  weblogs[2].id.to_s
      run = CF::Run.create("adult-website-moderation", + run_title,
        [
          {"url" => weblogs[0].url.to_s, "meta_data" => weblogs[0].id.to_s},
          {"url" => weblogs[1].url.to_s, "meta_data" => weblogs[1].id.to_s},
          {"url" => weblogs[2].url.to_s, "meta_data" => weblogs[2].id.to_s}
        ])
      if run.present?
        weblogs.each do |weblog|
          weblog.porn = "pending"
          weblog.save!
        end
      end
      
      puts ('++++++++++++++++++++++++++++++++++++++++++  RUN')
      puts (run.inspect)            
    end
  end
      
end