class Ad < ActiveRecord::Base
  self.table_name = "ad"
  self.primary_key = "ad_id"

	def self.random
		find(:first, :order => 'RAND()')
	end
	
 end