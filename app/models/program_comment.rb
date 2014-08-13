class ProgramComment  < ActiveRecord::Base
	establish_connection(:mogolocal)

	belongs_to :program

	self.table_name = "program_comments"
end