class Location < ActiveRecord::Base
	establish_connection(:mogolog)

  self.table_name = "locations"
end