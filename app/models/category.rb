class Category  < ActiveRecord::Base
	has_many :channel_categorys
	has_many :category_programs
	has_many :programs, :through => :category_programs, :order => :weight, :conditions => "enable_yn = 'y' and enable_start_date <= now() and enable_end_date >= now()"  
  has_and_belongs_to_many :categorys, :join_table => "category_category", :foreign_key => "parent_category_id", :association_foreign_key => "child_category_id", :order => :weight
  belongs_to :sponsor

  self.table_name = "categorys"
  self.primary_key = "category_id"

	def self.findByProgramId(program_id)
		categorys = Category.find_by_sql ["select c.* from mogo2.categorys c inner join mogo2.category_program cp on (c.category_id = cp.category_id) where cp.program_id=?", program_id]
		return categorys[0]
	end
	
	def self.findParents(category_id)
		parentCategorys = Category.find_by_sql ["select c.* from mogo2.categorys c inner join mogo2.category_category cc on (c.category_id = cc.parent_category_id) where cc.child_category_id=?", category_id]
		return parentCategorys
	end
end 