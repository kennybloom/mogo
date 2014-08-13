class SyncController < ApplicationController
  require 'find2'

  # ==================================
	# tudou_status
	# ==================================
  def tudou_status
  	program_id = params[:clientItemId]
  	tudou_id = params[:tudouItemId]
  	tudou_status = params[:status]
  	
  	if program_id == nil
	  	program_id = "" 
  	else	
			program_id_ary = program_id.split("-")
			if program_id_ary.size > 1
				program_id = program_id_ary[0]
			end
		end

  	tudou_id = "" if tudou_id == nil
  	tudou_status = "" if tudou_status == nil
  	
  	puts "tudou_status: program id:" + program_id + " tudou id:" + tudou_id + " status:" + tudou_status

		@return_status = "Success"

		begin
			program = Program.find(program_id)  	
			program.update_attributes({:tudou_id=>tudou_id, :tudou_status=>tudou_status})
		rescue
			@return_status = "Failure"
		end
	end

  # ==================================
	# foo_post
	# ==================================
require 'net/http'
  def foo_post
  	
    res = Net::HTTP.post_form(URI.parse('http://localhost:3000/sync/foo_receive'),
    {'title'=>'xxx', 'tags'=>'my tags'})
	end

  # ==================================
	# foo_receive
	# ==================================
  def foo_receive
  	title = params[:title]
  	tags = params[:tags]
  	
  	puts "title:" + title + " tags:" + tags
  	
  	if params['Filedata'].length > 0
			incoming_file = params['Filedata']		
			base_file_name = incoming_file.original_filename
			File.open("#{RAILS_ROOT}/#{base_file_name}", "wb") do |f| 
				f.write(incoming_file.read)
			end 
		end

	end

  # ==================================
	# fix_log
	# ==================================
  def fix_log
  
  	#fix_log_step1("/home/awstats/logbf")  	
  	#fix_log_step1("/home/awstats/logbg")		
		#fix_log_step1("/home/awstats/logbh")
		#fix_log_step1("/home/awstats/logbi")
		#fix_log_step1("/home/awstats/logbj")
		#fix_log_step1("/home/awstats/logbk")
		#fix_log_step1("/home/awstats/logbl")
		#fix_log_step1("/home/awstats/logbm")
		#fix_log_step1("/home/awstats/logbn")
		#fix_log_step1("/home/awstats/logbo")
		
		#fix_log_step2("2008-09-01 0:0:0", "2008-09-01 23:59:59")
		#fix_log_step2("2008-09-02 0:0:0", "2008-09-02 23:59:59")
		#fix_log_step2("2008-09-03 0:0:0", "2008-09-03 23:59:59")
		#fix_log_step2("2008-09-04 0:0:0", "2008-09-04 23:59:59")
		#fix_log_step2("2008-09-05 0:0:0", "2008-09-05 23:59:59")
		#fix_log_step2("2008-09-06 0:0:0", "2008-09-06 23:59:59")
  end


  # ==================================
	# sync_db
	# ==================================
  def sync_db  	
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

			IO.popen($sync_slave_cmd + " < " +  $path_dbsync + "/" + sync_file + " >> " + $path_dbsync + "/sync.out")
			IO.popen("echo " + max_syncnumber.to_s + " > " + $path_dbsync + "/sync.num")
			IO.popen("echo " + sync_file + " " + DateTime.now.to_s + " >> " + $path_dbsync + "/sync.log")
			IO.popen("rm -rf " + $path_mogo + "/public/index.html")
			IO.popen("rm -rf " + $path_mogo + "/public/mogo/*")
			IO.popen("rm -rf " + $path_mogo + "/tmp/cache/*")
			
			@message += "Synchronized with file: " + sync_file
		else
			@message += "Nothing to sync."
		end
  end
  

	# ==================================
	# ----------------------------------
	# summary methods
	# ----------------------------------
	# ==================================

  # ==================================
	# summarize_now
	# ==================================
	def summarize_now
		now = Time.now
		year = now.year
		month = now.month
		day = now.day
		hour = now.hour
		
		update_video_log_location_id
		
		_summarize_to_date(year, month, day, hour)
	end

  # ==================================
	# summarize_to_date
	# ==================================
	def summarize_to_date
		year = params[:year]
		month = params[:month]
		day = params[:day]
		hour = param[:hour]
		
		update_video_log_location_id
		
		_summarize_to_date(year, month, day, hour)
	end

  # ==================================
	# summarize_2008_leap
	# ==================================
	def summarize_2008_leap
		update_video_log_location_id
		
		_summarize_to_date(2008, 2, 29, 23)
	end

  # ==================================
	# summarize_2007
	# ==================================
	def summarize_2007
		update_video_log_location_id
		
		_summarize_to_date(2007, 12, 31, 23)
	end

  # ==================================
	# update_video_log_location_id
	# ==================================
	def update_video_log_location_id
		video_logs = VideoLog.find(:all, :conditions => "user_ip is not null and user_location_id is null")
		locations = Location.find(:all)

		ci = CNIP.new('public/QQWry_utf8.dat')

		for video_log in video_logs
			found = false
			begin
  			ciloc = ci.where(video_log.user_ip)
  		rescue
  		end
			if ciloc != nil
				for loc in locations
					pos = ciloc.country.index(loc.location)
					if pos != nil && pos == 0
						video_log.user_location_id = loc.id
						video_log.save
						found = true
						break
					end
				end
			end

			if !found
				video_log.user_location_id = 35
				video_log.save				
			end
		end
	end

	
	# ==================================
	# program_stats_update
	# ==================================
  def program_stats_update
  	lastndays = params[:lastndays]

		if lastndays != nil			
					
			# set all viewed count to 0
			Program.update_all("viewed = 0")

		  startDate = Date.today.to_time - (lastndays.to_i).days
			startDateStr = startDate.year.to_s + "-" + startDate.month.to_s + "-" + startDate.day.to_s
			sql = "select program_id, count(*) viewed from mogolog.video_log where created >= '" + startDateStr + "' group by program_id"

			stats = VideoLogCt.find_by_sql(sql)

			count = 0
			for stat in stats
				begin			
					program = Program.find(stat.program_id)
					program.viewed = stat.viewed
					program.save
					count += 1
				rescue ActiveRecord::RecordNotFound
				end
			end

  		@message = "Update completed. " + count.to_s + " programs updated."

		end

	end

	# ==================================
	# youku_xml
	# ==================================
	def youku_xml
		@uid = params[:uid]
		ids = params[:ids]
		@category = params[:category]
		
		if ids != nil
			id_array = ids.split("-")
		end
		
		@all_programs = []

		for channel_id in id_array
			channel = Channel.find(channel_id)
			cat_ids = "-1"
			categorys = channel.categorys
			  
			for category in categorys 
				subcategorys = category.categorys
			  if subcategorys.size > 0
			  	for subcategory in subcategorys
						cat_ids += "," + subcategory.category_id.to_s
			  	end
			  else
					cat_ids += "," + category.category_id.to_s
			  end
			end
			  
			sql = "select p.* from category_program cp, programs p where cp.category_id in (" + cat_ids + ") and cp.program_id = p.program_id" 
			programs = Program.find_by_sql(sql)

			for program in programs 
				@all_programs << program
			end

		end

	end
	
	# ==================================
	# ----------------------------------
	# private methods
	# ----------------------------------
	# ==================================
	private

  # ==================================
	# _summarize_to_date
	# ==================================
	def _summarize_to_date(year, month, day, hour)	
		$level = 0
		open_summary_log
		write_summary_log $level, "Summary processing started date=>" + year.to_s + "-" + month.to_s + "-" + day.to_s + " :" + hour.to_s
		
		if _sum_by_year(year, 'n')
			for m in 1..month
				complete = 'y'
				if m == month
					last_day = day
					complete = 'n'
				elsif m == 1 || m == 3 || m == 5 || m == 7 || m == 8 || m == 10 || m == 12
					last_day = 31
				elsif m == 2
					last_day = 29
				else
					last_day = 30
				end

				if _sum_by_month(year, m, complete)
					for d in 1..last_day
						complete = 'y'				
						if m == month && d == day
							last_hour = hour
							complete = 'n'				
						else
							last_hour = 23
						end

						if _sum_by_day(year, m, d, complete)
							for h in 0..last_hour
								complete = 'y'
								if m == month && d == day && h == hour
									complete = 'n'
								end

								_sum_by_hour(year, m, d, h, complete)
							end
						end
					end			
				end
			end
		end
		
		line = "Summary processing finished"
		write_summary_log $level, line
		close_summary_log

	end

  # ==================================
	# _sum_by_year
	# ==================================
	def _sum_by_year(year, complete)
		$level += 1
		
		# check if the year record exists
		begin
			sum_year = VideoLogSummaryYear.find(:first, :conditions=>"year=" + year.to_s)
		rescue ActiveRecord::RecordNotFound
		end

		if sum_year == nil
			sum_year = VideoLogSummaryYear.new
			sum_year.year = year
			write_summary_log $level, "sum by year: begin:" + year.to_s + " -> new row"
		else
			write_summary_log $level, "sum by year: begin:" + year.to_s + " -> existing row"
			if sum_year.complete == 'y'
				write_summary_log $level, "sum by year: end -> no processing"
				$level -= 1
				return false
			end
		end
		
		sql = "select count(*) count from video_log where created between '" + year.to_s + "-01-01 0:0:0' and '" + year.to_s + "-12-31 23:59:59'"
		sum_count = VideoLogSummaryYear.find_by_sql(sql)
				
		sql = "select count(distinct(user_unique_id)) count from video_log where created between '" + year.to_s + "-01-01 0:0:0' and '" + year.to_s + "-12-31 23:59:59'"
		sum_unique_users = VideoLogSummaryYear.find_by_sql(sql)

		sum_year.count = sum_count[0].count
		sum_year.unique_users = sum_unique_users[0].count
		sum_year.complete = complete
		sum_year.save
		
		write_summary_log $level, "sum by year: count: " + sum_year.count.to_s + " unique_users:" + sum_year.unique_users.to_s
		
		_sum_by_channel(sum_year.id, year, nil, nil, year, nil, nil)
		_sum_by_program(sum_year.id, year, nil, nil, year, nil, nil)
		_sum_by_location(sum_year.id, year, nil, nil, year, nil, nil)
		
		write_summary_log $level, "sum by year: end -> processed."
		$level -= 1
		return true
	end

  # ==================================
	# _sum_by_month
	# ==================================
	def _sum_by_month(year, month, complete)
		$level += 1
	
		sum_year = VideoLogSummaryYear.find(:first, :conditions=>"year=" + year.to_s)
		
		# check if the month record exists
		begin
			sum_month = VideoLogSummaryMonth.find(:first, :conditions=>"parent_id=" + sum_year.id.to_s + " and year=" + year.to_s + " and month=" + month.to_s )
		rescue ActiveRecord::RecordNotFound
		end

		if sum_month == nil
			sum_month = VideoLogSummaryMonth.new
			sum_month.parent_id = sum_year.id
			sum_month.year = year
			sum_month.month = month
			write_summary_log $level, "sum by month: begin:" + year.to_s + "-" + month.to_s + " -> new row"
		else
			write_summary_log $level, "sum by month: begin:" + year.to_s + "-" + month.to_s + " -> existing row"
			if sum_month.complete == 'y'
				write_summary_log $level, "sum by month: end -> no processing"
				$level -= 1
				return false
			end
		end

		#calculate last day of the month
		if month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12
			last_day = 31
		elsif month == 2
			last_day = 29
		else
			last_day = 30
		end

		sql = "select count(*) count from video_log where created between '" + year.to_s + "-" + month.to_s + "-01 0:0:0' and '" + year.to_s + "-" + month.to_s + "-" + last_day.to_s + " 23:59:59'"		
		sum_count = VideoLogSummaryMonth.find_by_sql(sql)

		sql = "select count(distinct(user_unique_id)) count from video_log where created between '" + year.to_s + "-" + month.to_s + "-01 0:0:0' and '" + year.to_s + "-" + month.to_s + "-" + last_day.to_s + " 23:59:59'"		
		sum_unique_users = VideoLogSummaryMonth.find_by_sql(sql)

		sum_month.count = sum_count[0].count
		sum_month.unique_users = sum_unique_users[0].count
		sum_month.complete = complete
		sum_month.save

		write_summary_log $level, "sum by month: count: " + sum_month.count.to_s + " unique_users:" + sum_month.unique_users.to_s

		_sum_by_channel(sum_month.id, year, month, nil, year, month, last_day)
		_sum_by_program(sum_month.id, year, month, nil, year, month, last_day)
		_sum_by_location(sum_month.id, year, month, nil, year, month, last_day)
		
		write_summary_log $level, "sum by month: end -> processed."
		$level -= 1
		return true
	end

  # ==================================
	# _sum_by_day
	# ==================================
	def _sum_by_day(year, month, day, complete)
		$level += 1
		
		sum_month = VideoLogSummaryMonth.find(:first, :conditions=>"year=" + year.to_s + " and month=" + month.to_s)
		
		return unless sum_month != nil
		
		# check if the day record exists
		begin
			sum_day = VideoLogSummaryDay.find(:first, :conditions=>"parent_id=" + sum_month.id.to_s + " and year=" + year.to_s + " and month=" + month.to_s + " and day=" + day.to_s)
		rescue ActiveRecord::RecordNotFound
		end

		if sum_day == nil
			sum_day = VideoLogSummaryDay.new
			sum_day.parent_id = sum_month.id
			sum_day.year = year
			sum_day.month = month
			sum_day.day = day
			write_summary_log $level, "sum by day: begin:" + year.to_s + "-" + month.to_s + "-" + day.to_s + " -> new row"
		else
			write_summary_log $level, "sum by day: begin:" + year.to_s + "-" + month.to_s + "-" + day.to_s + " -> existing row"
			if sum_day.complete == 'y'
				write_summary_log $level, "sum by day: end -> no processing"
				$level -= 1
				return false
			end
		end

		sql = "select count(*) count from video_log where created between '" + year.to_s + "-" + month.to_s + "-" + day.to_s + " 0:0:0' and '" + year .to_s+ "-" + month.to_s + "-" + day.to_s + " 23:59:59'"		
		sum_count = VideoLogSummaryDay.find_by_sql(sql)

		sql = "select count(distinct(user_unique_id)) count from video_log where created between '" + year.to_s + "-" + month.to_s + "-" + day.to_s + " 0:0:0' and '" + year .to_s+ "-" + month.to_s + "-" + day.to_s + " 23:59:59'"		
		sum_unique_users = VideoLogSummaryDay.find_by_sql(sql)

		sum_day.count = sum_count[0].count
		sum_day.unique_users = sum_unique_users[0].count
		sum_day.complete = complete
		sum_day.save

		write_summary_log $level, "sum by day: count: " + sum_day.count.to_s + " unique_users:" + sum_day.unique_users.to_s

		_sum_by_channel(sum_day.id, year, month, day, year, month, day)
		_sum_by_program(sum_day.id, year, month, day, year, month, day)
		_sum_by_location(sum_day.id, year, month, day, year, month, day)
		
		write_summary_log $level, "sum by day: end -> processed."
		$level -= 1
		return true
	end

  # ==================================
	# _sum_by_hour
	# ==================================
	def _sum_by_hour(year, month, day, hour, complete)
		$level += 1
		
		sum_day = VideoLogSummaryDay.find(:first, :conditions=>"year=" + year.to_s + " and month=" + month.to_s + " and day=" + day.to_s)
		
		return unless sum_day != nil
		
		# check if the day record exists
		begin
			sum_hour = VideoLogSummaryHour.find(:first, :conditions=>"parent_id=" + sum_day.id.to_s + " and year=" + year.to_s + " and month=" + month.to_s + " and day=" + day.to_s + " and hour=" + hour.to_s)
		rescue ActiveRecord::RecordNotFound
		end

		if sum_hour == nil
			sum_hour = VideoLogSummaryHour.new
			sum_hour.parent_id = sum_day.id
			sum_hour.year = year
			sum_hour.month = month
			sum_hour.day = day
			sum_hour.hour = hour
			write_summary_log $level, "sum by hour: begin:" + year.to_s + "-" + month.to_s + "-" + day.to_s + ": " + hour.to_s + " -> new row"
		else
			write_summary_log $level, "sum by hour: begin:" + year.to_s + "-" + month.to_s + "-" + day.to_s + ": " + hour.to_s + " -> existing row"
			if sum_hour.complete == 'y'
				write_summary_log $level, "sum by hour: end -> no processing"
				$level -= 1
				return false
			end
		end

		sql = "select count(*) count from video_log where created between '" + year.to_s + "-" + month.to_s + "-" + day.to_s + " " + hour.to_s + ":0:0' and '" + year.to_s + "-" + month.to_s + "-" + day.to_s + " " + hour.to_s + ":59:59'"
		sum_count = VideoLogSummaryHour.find_by_sql(sql)

		sql = "select count(distinct(user_unique_id)) count from video_log where created between '" + year.to_s + "-" + month.to_s + "-" + day.to_s + " " + hour.to_s + ":0:0' and '" + year.to_s + "-" + month.to_s + "-" + day.to_s + " " + hour.to_s + ":59:59'"
		sum_unique_users = VideoLogSummaryDay.find_by_sql(sql)

		sum_hour.count = sum_count[0].count
		sum_hour.unique_users = sum_unique_users[0].count
		sum_hour.complete = complete
		sum_hour.save

		write_summary_log $level, "sum by hour: count: " + sum_hour.count.to_s

		write_summary_log $level, "sum by hour: end -> processed."
		$level -= 1
		return true
	end

  # ==================================
	# _sum_by_channel
	# ==================================
	def _sum_by_channel(parent_id, start_year, start_month, start_day, end_year, end_month, end_day)
		$level += 1
		
		start_month = 1  unless start_month != nil
		start_day   = 1  unless start_day   != nil
		end_month   = 12 unless end_month   != nil
		end_day     = 31 unless end_day     != nil

		write_summary_log $level, "sum by channel: begin: from " + 
			start_year.to_s + "-" + start_month.to_s + "-" + start_day.to_s + " to " +
			end_year.to_s + "-" + end_month.to_s + "-" + end_day.to_s + 
			" parent_id:" + parent_id.to_s

		# for each channel
    channels = Channel.find(:all, :order => :weight)
		for channel in channels
			begin
				sum_channel = VideoLogSummaryChannel.find(:first, :conditions=>"parent_id=" + parent_id.to_s + " and channel_id=" + channel.channel_id.to_s)
			rescue ActiveRecord::RecordNotFound
			end
			
			if sum_channel == nil
				sum_channel = VideoLogSummaryChannel.new
				sum_channel.parent_id = parent_id
				sum_channel.channel_id = channel.channel_id
				sum_channel.channel_name = channel.channel_name
				write_summary_log $level, "sum by channel: channel_id:" + channel.channel_id.to_s + " -> new row"
			else
				write_summary_log $level, "sum by channel: channel_id:" + channel.channel_id.to_s + " -> existing row"
			end

			sql = "select count(*) count from video_log where channel_id=" + channel.channel_id.to_s + " and created between '" + start_year.to_s + "-" + start_month.to_s + "-" + start_day.to_s + " 0:0:0' and '" + end_year.to_s + "-" + end_month.to_s + "-" + end_day.to_s + " 23:59:59'"
			sum_count = VideoLogSummaryChannel.find_by_sql(sql)

			sql = "select count(distinct(user_unique_id)) count from video_log where channel_id=" + channel.channel_id.to_s + " and created between '" + start_year.to_s + "-" + start_month.to_s + "-" + start_day.to_s + " 0:0:0' and '" + end_year.to_s + "-" + end_month.to_s + "-" + end_day.to_s + " 23:59:59'"
			sum_unique_users = VideoLogSummaryChannel.find_by_sql(sql)

			sum_channel.count = sum_count[0].count
			sum_channel.unique_users = sum_unique_users[0].count
			sum_channel.save

			write_summary_log $level, "sum by channel: channel_id:" + channel.channel_id.to_s + " count: " + sum_channel.count.to_s + " unique_users:" + sum_channel.unique_users.to_s
		end

		write_summary_log $level, "sum by channel: end -> processed."
		$level -= 1
		return true
	end

  # ==================================
	# _sum_by_program
	# ==================================
	def _sum_by_program(parent_id, start_year, start_month, start_day, end_year, end_month, end_day)
		$level += 1
		
		start_month = 1  unless start_month != nil
		start_day   = 1  unless start_day   != nil
		end_month   = 12 unless end_month   != nil
		end_day     = 31 unless end_day     != nil

		write_summary_log $level, "sum by program: begin: from " + 
			start_year.to_s + "-" + start_month.to_s + "-" + start_day.to_s + " to " +
			end_year.to_s + "-" + end_month.to_s + "-" + end_day.to_s + 
			" parent_id:" + parent_id.to_s

		# delete existing programs
		VideoLogSummaryProgram.delete_all("parent_id = " + parent_id.to_s)
		
		sql = "SELECT channel_id, category_id, program_id, count(program_id) count FROM video_log " +
 			" where created between '" + start_year.to_s + "-" + start_month.to_s + "-" + start_day.to_s + " 0:0:0' and '" + end_year.to_s + "-" + end_month.to_s + "-" + end_day.to_s + " 23:59:59'" +
 			" group by program_id "

		sum_records = VideoLogSummaryProgram.find_by_sql(sql)

		for sum_record in sum_records
			begin
				channel = Channel.find(sum_record.channel_id)
			rescue ActiveRecord::RecordNotFound
				channel_name = ""
			else
				channel_name = channel.channel_name
			end

			begin
				category = Category.find(sum_record.category_id)
			rescue ActiveRecord::RecordNotFound
				category_name = ""
			else
				category_name = category.category_name_cn
			end

			begin
				program = Program.find(sum_record.program_id)
			rescue ActiveRecord::RecordNotFound
				program_name = ""
			else
				program_name = program.program_name_cn
			end
		
			if program_name.size > 0
				sum_program = VideoLogSummaryProgram.new
				sum_program.parent_id = parent_id
				sum_program.channel_id = sum_record.channel_id
				sum_program.channel_name = channel_name
				sum_program.category_id = sum_record.category_id
				sum_program.category_name = category_name
				sum_program.program_id = sum_record.program_id
				sum_program.program_name = program_name
				sum_program.count = sum_record.count
				sum_program.save
			end
		end

		sql = "SELECT channel_id, category_id, program_id, count(distinct(user_unique_id)) unique_users FROM video_log " +
 			" where created between '" + start_year.to_s + "-" + start_month.to_s + "-" + start_day.to_s + " 0:0:0' and '" + end_year.to_s + "-" + end_month.to_s + "-" + end_day.to_s + " 23:59:59'" +
 			" group by program_id "

		sum_records = VideoLogSummaryProgram.find_by_sql(sql)
		
		for sum_record in sum_records
			sum_program = VideoLogSummaryProgram.find(:first, :conditions => "parent_id=" + parent_id.to_s + " and program_id=" + sum_record.program_id.to_s)
			if sum_program != nil
				sum_program.unique_users = sum_record.unique_users
				sum_program.save
			end
		end

		write_summary_log $level, "sum by program: end -> processed."
		$level -= 1
		return true
	end

  # ==================================
	# _sum_by_location
	# ==================================
	def _sum_by_location(parent_id, start_year, start_month, start_day, end_year, end_month, end_day)
		$level += 1
		
		start_month = 1  unless start_month != nil
		start_day   = 1  unless start_day   != nil
		end_month   = 12 unless end_month   != nil
		end_day     = 31 unless end_day     != nil
		
		write_summary_log $level, "sum by location: begin: from " + 
			start_year.to_s + "-" + start_month.to_s + "-" + start_day.to_s + " to " +
			end_year.to_s + "-" + end_month.to_s + "-" + end_day.to_s + 
			" parent_id:" + parent_id.to_s

		# for each location 
    locations = Location.find(:all)
		for location in locations
			begin
				sum_location = VideoLogSummaryLocation.find(:first, :conditions=>"parent_id=" + parent_id.to_s + " and location_id=" + location.id.to_s)
			rescue ActiveRecord::RecordNotFound
			end
			
			if sum_location == nil
				sum_location = VideoLogSummaryLocation.new
				sum_location.parent_id = parent_id
				sum_location.location_id = location.id
				sum_location.location = location.location
				sum_location.location_en = location.location_en
				write_summary_log $level, "sum by location: location_id:" + location.id.to_s + " -> new row"
			else
				write_summary_log $level, "sum by location: location_id:" + location.id.to_s + " -> existing row"
			end

			sql = "select count(*) count from video_log where user_location_id=" + location.id.to_s + " and created between '" + start_year.to_s + "-" + start_month.to_s + "-" + start_day.to_s + " 0:0:0' and '" + end_year.to_s + "-" + end_month.to_s + "-" + end_day.to_s + " 23:59:59'"
			sum_count = VideoLogSummaryLocation.find_by_sql(sql)

			sql = "select count(distinct(user_unique_id)) count from video_log where user_location_id=" + location.id.to_s + " and created between '" + start_year.to_s + "-" + start_month.to_s + "-" + start_day.to_s + " 0:0:0' and '" + end_year.to_s + "-" + end_month.to_s + "-" + end_day.to_s + " 23:59:59'"
			sum_unique_users = VideoLogSummaryLocation.find_by_sql(sql)

			sum_location.count = sum_count[0].count
			sum_location.unique_users = sum_unique_users[0].count
			sum_location.save

			write_summary_log $level, "sum by location: location_id:" + location.id.to_s + " count: " + sum_location.count.to_s + " unique_users:" + sum_location.unique_users.to_s
		end

		write_summary_log $level, "sum by location: end -> processed."
		$level -= 1
		return true
	end

  # ==================================
	# open_summary_log
	# ==================================
	def open_summary_log
		$sumlog = File.open("log/summary.log", "w+")
	end
	
  # ==================================
	# write_summary_log
	# ==================================
	def write_summary_log(level, line)
		line_space = ""
		level.times {
			line_space += "     "
		}
		line = Time.now.strftime("%y-%m-%d %H:%M:%S") + " " + line_space + line
	
		$sumlog.puts line
	end

  # ==================================
	# close_summary_log
	# ==================================
	def close_summary_log
		$sumlog.close
	end

  # ==================================
	# fix_log_step1
	# ==================================
  def fix_log_step1(filepath)
		counter = 1
		begin
			fin = File.new(filepath, "r")
			fout = File.new(filepath + ".out", "w")
			
			while (line = fin.gets)
					if line =~ /GET \/mogo\/play_video\//
						if !(line =~ /\/mogo\/play_video\/intro/) && !(line =~ /\/mogo\/play_video\/null/)

							fout.puts "#{counter}: #{line}"
							puts "#{counter}: #{line}"

							# get the ip
							if line =~ /^.\d+\.\d+\.\d+\.\d+/
								ip = $&
								fout.puts "IP:#{ip}"
							end
							
							# get the date
							if line =~ /\[.*\+/
							  sdate = $&
								sdate = sdate.slice(1..sdate.length-2)
								fout.puts "DATE:#{sdate}"
								
								log_date = DateTime.strptime(sdate, "%d/%b/%Y:%H:%M:%S")
								fout.puts "DATE2:" +  log_date.strftime("%m/%d/%Y %H:%M:%S")
							end
							
							# get the video info
							if line =~ /play_video\/.+\sHTTP/
								video_info = $&
								video_info = video_info.slice(11..video_info.length-6)
								video_info_array = video_info.split("-")
								
								if video_info_array != nil && video_info_array.size >= 3
									channel_id = video_info_array[0]
									category_id = video_info_array[1]
									program_id = video_info_array[2]
									
									if video_info_array.size == 4
										note = video_info_array[3]
									else
										note = ''
									end
									
									fout.puts "channel id:#{channel_id}, category id:#{category_id}, program id:#{program_id}, note:#{note}"
								end
							end

							VideoLogTmp.new do |v|
								v.user_ip = ip
								v.user_unique_id = ip
								v.program_id = program_id
								v.channel_id = channel_id
								v.category_id = category_id
								v.note = note
								v.syndication_id = 1
								v.created = log_date
								v.save
							end

							counter = counter + 1
						end
					end
										
					#if (counter > 1000)
					#	break
					#end
			end
			
			fout.close
			fin.close
		rescue => err
			puts "Exception: #{err}"
			err
		end
	  	
  end

	
  # ==================================
	# fix_log_step2
	# ==================================
  def fix_log_step2(start_time, end_time)
  	puts "*** fix log step2: start_time: #{start_time}, end_time: #{end_time}"
  
		sql = "SELECT * FROM video_log_tmp where created between '#{start_time}' and '#{end_time}' "

		log_records = VideoLogTmp.find_by_sql(sql)
		counter = 0

		for log_record in log_records
			VideoLog.new do |v|
				v.user_ip = log_record.user_ip
				v.user_unique_id = log_record.user_unique_id
				v.program_id = log_record.program_id
				v.channel_id = log_record.channel_id
				v.category_id = log_record.category_id
				v.note = log_record.note
				v.syndication_id = log_record.syndication_id
				v.created = log_record.created
				v.save
			end

			counter = counter + 1
		end

		puts "*** fix log step2: completed. #{counter} records transfered"
	end
  
end
