class CategoryProgram  < ActiveRecord::Base
    belongs_to :category
    belongs_to :program

  self.table_name = "category_program"
  set_primary_keys :program_id, :category_id
end