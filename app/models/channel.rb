class Channel  < ActiveRecord::Base
  has_many :channel_categorys
  has_many :categorys, :through => :channel_categorys, :order => :weight
  has_many :promotions
	belongs_to :sponsor

  self.table_name = "channel"
  self.primary_key = "channel_id"

	def self.findByCategoryId (category_id)
		channels = Channel.find_by_sql ["select c.* from mogo2.channel c inner join mogo2.channel_category cc on (c.channel_id = cc.channel_id) where cc.category_id=?", category_id]

		if channels.size > 0
			return channels[0]
		end

		parentCategorys = Category.find_by_sql ["select c.* from mogo2.categorys c inner join mogo2.category_category cc on (c.category_id = cc.parent_category_id) where cc.child_category_id=?", category_id]

		if parentCategorys.size == 0
			return nil
		end

		for parent_category in parentCategorys
			channels = Channel.find_by_sql ["select c.* from mogo2.channel c inner join mogo2.channel_category cc on (c.channel_id = cc.channel_id) where cc.category_id=?", parent_category.category_id]
			if channels.size > 0
				return channels[0]
			end
		end

		return nil

	end
end