namespace :mogosync do

  # ==================================
	# dump_db
	# ==================================
  desc "dump_db: start synchronize database"
	task(:dump_db  => :environment) do
		IO.popen($dump_master_cmd + " > " +  $path_dbsync + "/mogo.sql." + Time.now.to_i.to_s)
  end

  # ==================================
	# sync_db
	# ==================================
  desc "sync_db: synchronize database"
	task(:sync_db  => :environment) do
	
  	@message = ""
  	begin
	  	f = File.open($path_dbsync + "/sync.num", 'r')  
			last_syncnumber = f.read.to_i
			f.close  
			@message = "last sync file number: " + last_syncnumber.to_s + ". "
		rescue
			@message = "Can't open sync.num file. "
			last_syncnumber = 0
		end
  
		max_syncnumber = 0
		Find2.find({"follow" => true}, $path_dbsync) do |path|
			if !FileTest.directory?(path) && path =~ /.*mogo\.sql.*/
				basename = File.basename(path) 
				
				syncnumber = basename.gsub("mogo.sql.", "").to_i
				max_syncnumber = syncnumber unless syncnumber < max_syncnumber
			end	
		end

		if max_syncnumber > last_syncnumber
			sync_file = "mogo.sql." + max_syncnumber.to_s 

			puts $sync_slave_cmd + " < " +  $path_dbsync + "/" + sync_file + " >> " + $path_dbsync + "/sync.out"
			IO.popen($sync_slave_cmd + " < " +  $path_dbsync + "/" + sync_file + " >> " + $path_dbsync + "/sync.out." + max_syncnumber.to_s)
			IO.popen("echo " + max_syncnumber.to_s + " > " + $path_dbsync + "/sync.num")
			IO.popen("echo " + sync_file + " " + DateTime.now.to_s + " >> " + $path_dbsync + "/sync.log." + max_syncnumber.to_s)
			IO.popen("rm -rf " + $path_mogo + "/public/index.html")
			IO.popen("rm -rf " + $path_mogo + "/public/mogo/*")
			IO.popen("rm -rf " + $path_mogo + "/tmp/cache/*")
			
			@message += "Synchronized with file: " + sync_file
		else
			@message += "Nothing to sync."
		end

		puts @message

	end

  # ==================================
	# keep_alive
	# ==================================
  desc "keep_alive: does nothing, keep database connection alive"
	task(:keep_alive  => :environment) do
		channel = Channel.find(:all, :limit=>1)
	end 

 
end