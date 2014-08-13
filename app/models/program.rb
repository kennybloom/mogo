class Program  < ActiveRecord::Base
	require 'composite_primary_keys'
	require 'acts_as_ferret'

	has_many :category_programs
	has_many :promotions
	has_many :program_comments
	has_many :program_recommends

  self.table_name = "programs"
  self.primary_key = "program_id"

	acts_as_ferret :fields => {
		:auto_keywords_1 => {:boost => 16}, 
		:auto_keywords_2 => {:boost => 8}, 
		:auto_keywords_3 => {:boost => 32}, 
		:auto_keywords_4 => {:boost => 2}, 
		:auto_keywords_5 => {:boost => 0}
	}	
	
end