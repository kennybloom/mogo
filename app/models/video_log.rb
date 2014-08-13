class VideoLog < ActiveRecord::Base
	establish_connection(:mogolog)

  self.table_name = "video_log"
end