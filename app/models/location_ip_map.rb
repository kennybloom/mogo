class LocationIpMap < ActiveRecord::Base
	establish_connection(:mogolog)

  self.table_name = "location_ip_maps"
end