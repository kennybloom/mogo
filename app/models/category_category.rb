class CategoryCategory  < ActiveRecord::Base
	require 'composite_primary_keys'

	belongs_to :category
	has_many :categorys

  self.table_name = "category_category"
  set_primary_keys :parent_category_id, :child_category_id
end