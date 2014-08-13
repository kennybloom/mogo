class Billboard  < ActiveRecord::Base
  self.table_name = "billboards"

	def self.random
		find(:first, :order => 'RAND()')
	end
end