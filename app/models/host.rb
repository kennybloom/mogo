class Host  < ActiveRecord::Base
    has_many :programs
  self.table_name = "hosts"
  self.primary_key = "host_id"
end