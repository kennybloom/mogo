class ImportedIpLocation < ActiveRecord::Base
	establish_connection(:mogolog)

  self.table_name = "imported_ip_locations"
end