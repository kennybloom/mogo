class WebAd < ActiveRecord::Base
  self.table_name = "web_ads"
  self.primary_key = "id"

	def self.random
		find(:first, :order => 'RAND()')
	end
	
 end