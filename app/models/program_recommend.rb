class ProgramRecommend  < ActiveRecord::Base
	establish_connection(:mogolocal)

	belongs_to :program

	self.table_name = "program_recommends"
end