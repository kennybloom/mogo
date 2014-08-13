module AdminHelper
  require 'find2'

	# ==================================
	# list_weights
	# ==================================
	def list_weights
		[-20,-19,-18,-17,-16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1, 0, 
		1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,
		31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50]
	end

	# ==================================
	# list_display_weights
	# ==================================
	def list_display_weights
		[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,
		51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100]
	end

	# ==================================
	# list_web_ad_panels
	# ==================================
	def list_web_ad_panels
		['top center', 'top right']
	end

	# ==================================
	# list_unlinked_channel_categories
	# ==================================
	def list_unlinked_channel_categories(channel_id)
		#build a list of all categories
		list = []
		categorys = Category.find(:all, :order => "category_name_cn")
		for category in categorys
			list << [category.category_name_cn, category.id]
		end

		#remove from the list already linked in categories
		channel_categorys = ChannelCategory.find(:all, :conditions => {:channel_id => channel_id})
		for channel_category in channel_categorys
			list.delete_if {|x| 
				x[1] == channel_category.category_id
			}
			
		end
	
		return list
	end

	# ==================================
	# list_unlinked_category_categories
	# ==================================
	def list_unlinked_category_categories(category_id)
		#build a list of all categories
		list = []
		categorys = Category.find(:all, :order => "category_name_cn")
		for category in categorys
			list << [category.category_name_cn, category.id]
		end

		#remove from the list already linked in categories
		list.delete_if {|x| 
			x[1] == category_id
		}
		
		category_categorys = CategoryCategory.find(:all, :conditions => {:parent_category_id => category_id})
		for category_category in category_categorys
			list.delete_if {|x| 
				x[1] == category_category.child_category_id
			}
			
		end
	
		return list
	end

	# ==================================
	# list_unlinked_programs
	# ==================================
	def list_unlinked_programs(category_id)
		#build a list of all programs
		list = []
		programs = Program.find(:all, :order => "program_name_cn")
		for program in programs
			list << [program.program_name_cn, program.id]
		end

		#remove from the list already linked in programs
		category_programs = CategoryProgram.find(:all, :conditions => {:category_id => category_id})
		for category_program in category_programs
			list.delete_if {|x| x[1] == category_program.program_id}
		end
	
		return list
	end

	# ==================================
	# file_select_options
	# ==================================
	def file_select_options(dirs, filter)
		list = ["<option value=''>-- select --</option>"]
		for dir in dirs
  		Find2.find({"follow" => true}, dir) do |path|
    		if !FileTest.directory?(path) && path =~ filter
    			basename = File.basename(path) 
					list << "<option>" + basename + "</option>"
				end	
  		end
		end
		list.sort!
		return list
	end
	
	# ==================================
	# video_dir_select_options
	# ==================================
	def video_dir_select_options(dirs, filter)
		list = ["<option value=''>-- folder --</option>"]
		for dir in dirs
  		Find2.find({"follow" => true}, dir) do |path|
    		if FileTest.directory?(path) && path =~ filter
    			dirname = path.sub($path_video_root,"")
    			if dirname[0,1] == "/"
						dirname.sub!("/", "")
					end
					dirvalue = $path_video_root + "/" + dirname
					if dirname.size > 0 && dirname[0,1] != "." && dirname[0, $dir_graphics.size] != $dir_graphics
						list << "<option value='" + dirvalue + "'>" + dirname + "</option>"
					end
				end	
  		end
		end
		list.sort!
		return list
	end

	# ======================================
	# video_thumb_dir_select_options
	# ======================================
	def video_thumb_dir_select_options(dirs, filter)
		list = ["<option value=''>-- folder --</option>"]
		for dir in dirs
  		Find2.find({"follow" => false}, dir) do |path|
    		if FileTest.directory?(path) && path =~ filter
    			dirname = path.sub($path_video_thumb_root,"")
    			if dirname[0,1] == "/"
						dirname.sub!("/", "")
					end
					dirvalue = $path_video_thumb_root + "/" + dirname
					if dirname.size > 0 && dirname[0,1] != "." && !(dirname =~ /\//) 
						list << "<option value='" + dirvalue + "'>" + dirname + "</option>"
					end
				end	
  		end
		end
		list.sort!
		return list
	end

	# ==================================
	# file_select_dir_list
	# ==================================
	def file_select_dir_list(dirs, filter)
		list = []
		for dir in dirs
  		Find2.find({"follow" => true}, dir) do |path|
    		if FileTest.directory?(path) && path =~ filter
    			dirname = path.sub($path_video_root,"")
    			if dirname == ""
    				dirname = "root"
    			elsif dirname[0,1] == "/"
    				dirname.sub!("/", "")
    			end
					if dirname[0,1] != "."
						list << dirname
					end
				end	
  		end
		end
		list.sort!
		return list
	end

end

