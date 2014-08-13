class ChannelCategory  < ActiveRecord::Base
	belongs_to :channel
	belongs_to :category

  self.table_name = "channel_category"
  set_primary_keys :channel_id, :category_id
end