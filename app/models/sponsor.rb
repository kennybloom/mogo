class Sponsor  < ActiveRecord::Base
    has_many :categorys
    has_many :channels
  self.table_name = "sponsors"
end