class StatsController < ApplicationController
  require 'cnip'

	layout 'stats', :except => [:index, :frame_left, :frame_center,  
		:show_stats_year_all_xml, :show_stats_month_all_xml, 
		:show_stats_day_all_xml, :show_stats_channel_all_xml, :show_stats_location_all_xml]

  before_filter :stats_authorize

	# ==================================
	# index
	# ==================================
	def index
	end

	# ==================================
	# ----------------------------------
	# stats methods
	# ----------------------------------
	# ==================================
	
	# ==================================
	# show_stats_all
	# ==================================
	def show_stats_all
		year_s = params[:year]
		month_s = params[:month]
		day_s = params[:day]
		syndication_id_s = params[:syndication_id]
		nprograms_s = params[:nprogram]

		if nprograms_s == nil
			@nprograms = 10
		else
			@nprograms = nprograms_s.to_i
		end
		
		if syndication_id_s == nil
			@syndication_id = "1"
		else
			@syndication_id = syndication_id_s.to_i
		end

		if year_s == nil
			now = Time.now
			year_s = now.year.to_s
			month_s = "all"
			day_s = "all"
		end
		
		if month_s == "all" && day_s != "all"
			flash[:notice] = 'Please select a month.'
			return
		end

		if (month_s == "all" && day_s == "all")
			@graph_unit = "year"
			@year = year_s.to_i 
			
			sum_year = VideoLogSummaryYearAll.find(:first, :conditions=>"year=" + @year.to_s + " and syndication_id=" + @syndication_id.to_s)
			@parent_id = sum_year.id unless sum_year == nil
			
		elsif (month_s != "all" && day_s == "all")
			@graph_unit = "month"
			@year = year_s.to_i
			@month = month_s.to_i
			
			sum_month = VideoLogSummaryMonthAll.find(:first, :conditions=>"year=" + @year.to_s + " and month=" + @month.to_s + " and syndication_id=" + @syndication_id.to_s)
			@parent_id = sum_month.id unless sum_month == nil

		elsif (month_s != "all" && day_s != "all")
			@graph_unit = "day"
			@year = year_s.to_i
			@month = month_s.to_i
			@day = day_s.to_i

			sum_day = VideoLogSummaryDayAll.find(:first, :conditions=>"year=" + @year.to_s + " and month=" + @month.to_s + " and day=" + @day.to_s + " and syndication_id=" + @syndication_id.to_s)
			@parent_id = sum_day.id unless sum_day == nil
		end
		
		@graph_unit = "unknown" if @parent_id == nil 

		if @parent_id != nil
			@sum_programs_by_count = VideoLogSummaryProgramAll.find(:all, :conditions=>"parent_id=" + @parent_id.to_s, :order=>"count desc")
			@sum_programs_by_unique_users = VideoLogSummaryProgramAll.find(:all, :conditions=>"parent_id=" + @parent_id.to_s, :order=>"unique_users desc")
		end

		@syndications = Syndication.find(:all)
	end

  # ==================================
	# show_stats_year_all_xml
	# ==================================
	def show_stats_year_all_xml
		@year = params[:year].to_i
		@syndication_id = params[:syndication_id].to_i
		@sum_months = VideoLogSummaryMonthAll.find(:all, :conditions=>"year=" + @year.to_s + " and syndication_id=" + @syndication_id.to_s, :order=>"year, month")
	end
	
  # ==================================
	# show_stats_month_all_xml
	# ==================================
	def show_stats_month_all_xml
		@year = params[:year].to_i
		@month = params[:month].to_i
		@syndication_id = params[:syndication_id].to_i
		@sum_days = VideoLogSummaryDayAll.find(:all, :conditions=>"year=" + @year.to_s + " and month=" + @month.to_s + " and syndication_id=" + @syndication_id.to_s, :order=>"year, month, day")
	end

  # ==================================
	# show_stats_day_all_xml
	# ==================================
	def show_stats_day_all_xml
		@year = params[:year].to_i
		@month = params[:month].to_i
		@day = params[:day].to_i
		@syndication_id = params[:syndication_id].to_i
		@sum_hours = VideoLogSummaryHourAll.find(:all, :conditions=>"year=" + @year.to_s + " and month=" + @month.to_s + " and day=" + @day.to_s + " and syndication_id=" + @syndication_id.to_s, :order=>"year, month, day, hour")
	end

  # ==================================
	# show_stats_channel_all_xml
	# ==================================
	def show_stats_channel_all_xml
		parent_id = params[:parent_id].to_i
		sum_channels = VideoLogSummaryChannelAll.find(:all, :conditions=>"parent_id=" + parent_id.to_s)
    all_channels = Channel.find(:all, :order => :weight, :conditions => "channel_id <> 8")
    @channel_names = []
    @channel_counts = []
    @channel_unique_users = []
    for channel in all_channels
    	for sum_channel in sum_channels
    		if channel.channel_id == sum_channel.channel_id
    			@channel_names << sum_channel.channel_name
    			@channel_counts << sum_channel.count
					@channel_unique_users << sum_channel.unique_users
    		end
    	end
    end
	end
	
  # ==================================
	# show_stats_location_all_xml
	# ==================================
	def show_stats_location_all_xml
		parent_id = params[:parent_id].to_i
		sum_locations = VideoLogSummaryLocationAll.find(:all, :conditions=>"parent_id=" + parent_id.to_s)
    all_locations = Location.find(:all)
    @location_names = []
    @location_counts = []
    @location_unique_users = []
    for location in all_locations
    	for sum_location in sum_locations
    		if location.id == sum_location.location_id && sum_location.count > 5
    			@location_names << location.location_en
    			@location_counts << sum_location.count
    			@location_unique_users << sum_location.unique_users
    		end
    	end
    end
	end

	# ==================================
	# list_logs_all
	# ==================================
	def list_logs_all
		@start_date = params['start_date']
		@end_date = params['end_date']
		@query_type = params['query_type']
		syndication_id_s = params[:syndication_id]

		condition = ""
		if @start_date != nil && @end_date != nil 
			condition = " where created >= '" + @start_date + " 00:00:00' and created <= '" + @end_date + " 23:59:59'"
		end

		if syndication_id_s != nil && syndication_id_s != "" && syndication_id_s != "0"
			@syndication_id = syndication_id_s.to_i
			condition += " and syndication_id=" + syndication_id_s
		else
			@syndication_id = 0
		end

		if @query_type == "program-archive" || @query_type == "user-archive"
			query_archive = true
		else
			query_archive = false
		end
		
		if @query_type == "program" || @query_type == "program-archive"
			query_program = true
		else
			query_program = false
		end

		if condition != ""
			if query_program
	    	if query_archive
					sql = "SELECT channel_id, category_id, program_id, count(program_id) program_count FROM video_log_archive " +
		    		condition + " group by channel_id, category_id, program_id "
					@logs = VideoLogArchiveAll.find_by_sql(sql)
	    	else
					sql = "SELECT channel_id, category_id, program_id, count(program_id) program_count FROM video_log " +
		    		condition + " group by channel_id, category_id, program_id "
					@logs = VideoLogAll.find_by_sql(sql)
				end

				# *** type: tree ***
	    	if query_archive
					sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'tree'"
					result = VideoLogArchiveAll.find_by_sql(sql)
				else
					sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'tree'"
					result = VideoLogAll.find_by_sql(sql)
				end
				@count_tree = result[0].count

				# *** type: auto ***
	    	if query_archive
					sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'auto'"
					result = VideoLogArchiveAll.find_by_sql(sql)
				else
					sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'auto'"
					result = VideoLogAll.find_by_sql(sql)
				end
				@count_auto = result[0].count

				# *** type: friend ***
	    	if query_archive
					sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'friend'"
					result = VideoLogArchiveAll.find_by_sql(sql)
				else
					sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'friend'"
					result = VideoLogAll.find_by_sql(sql)
				end
				@count_friend = result[0].count

				# *** type: next ***
	    	if query_archive
					sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'next'"
					result = VideoLogArchiveAll.find_by_sql(sql)
				else
					sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'next'"
					result = VideoLogAll.find_by_sql(sql)
				end
				@count_next = result[0].count

				# *** type: first ***
	    	if query_archive
					sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'first'"
					result = VideoLogArchiveAll.find_by_sql(sql)
				else
					sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'first'"
					result = VideoLogAll.find_by_sql(sql)
				end
				@count_first = result[0].count

				# *** type: search ***
	    	if query_archive
					sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'search'"
					result = VideoLogArchiveAll.find_by_sql(sql)
				else
					sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'search'"
					result = VideoLogAll.find_by_sql(sql)
				end
				@count_search = result[0].count

				# *** type: new ***
	    	if query_archive
					sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'new'"
					result = VideoLogArchiveAll.find_by_sql(sql)
				else
					sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'new'"
					result = VideoLogAll.find_by_sql(sql)
				end 
				@count_new = result[0].count

				# *** type: embed ***
	    	if query_archive
					sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'embed'"
					result = VideoLogArchiveAll.find_by_sql(sql)
				else
					sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'embed'"
					result = VideoLogAll.find_by_sql(sql)
				end
				@count_embed = result[0].count


				# *** type: recommend ***
				sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'recommend'"
	    	if query_archive
					sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'recommend'"
					result = VideoLogArchiveAll.find_by_sql(sql)
				else
					sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'recommend'"
					result = VideoLogAll.find_by_sql(sql)
				end
				@count_recommend = result[0].count


				# *** type: popular ***
	    	if query_archive
					sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'popular'"
					result = VideoLogArchiveAll.find_by_sql(sql)
				else
					sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'popular'"
					result = VideoLogAll.find_by_sql(sql)
				end
				@count_popular = result[0].count

				# *** type: related ***
	    	if query_archive
					sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'related'"
					result = VideoLogArchiveAll.find_by_sql(sql)
				else
					sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'related'"
					result = VideoLogAll.find_by_sql(sql)
				end
				@count_related = result[0].count

				# *** type: other ***
	    	if query_archive
					sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND (note is null OR note = '')"
					result = VideoLogArchiveAll.find_by_sql(sql)
				else
					sql = "SELECT count(*) count FROM video_log " + condition + " AND (note is null OR note = '')"
					result = VideoLogAll.find_by_sql(sql)
				end
				@count_null = result[0].count
			else
	    	if query_archive
					sql = "SELECT channel_id, category_id, program_id, count(distinct user_unique_id) user_count FROM video_log_archive " +
					condition + " group by channel_id, category_id, program_id "
					@logs = VideoLogArchiveAll.find_by_sql(sql)
				else
					sql = "SELECT channel_id, category_id, program_id, count(distinct user_unique_id) user_count FROM video_log " +
					condition + " group by channel_id, category_id, program_id "
					@logs = VideoLogAll.find_by_sql(sql)
				end

	    	if query_archive
					sql2 = "SELECT count(distinct user_unique_id) users FROM video_log_archive " + condition
					result = VideoLogArchiveAll.find_by_sql(sql2)
				else
					sql2 = "SELECT count(distinct user_unique_id) users FROM video_log " + condition
					result = VideoLogAll.find_by_sql(sql2)
				end
				@unique_users = result[0].users
			end

	  end  

		@syndications = Syndication.find(:all)
	end

	# ==================================
	# compare_synd
	# ==================================
	def compare_synd
		@start_date = params['start_date']
		@end_date = params['end_date']

		condition = ""
		if @start_date != nil && @end_date != nil 
			@condition = " where created >= '" + @start_date + " 00:00:00' and created <= '" + @end_date + " 23:59:59'"
		else
			@condition = ""
		end

		@channels = Channel.find(:all, :conditions => "channel_id <> 8")
	end

end
