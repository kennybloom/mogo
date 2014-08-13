class Promotion  < ActiveRecord::Base
  belongs_to :channel
  belongs_to :program

self.table_name = "promotion"
  self.primary_key = "promotion_id"

end