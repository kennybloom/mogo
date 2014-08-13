class MogoController < ApplicationController

    require 'cn_analyzer'

    caches_page :target_video, :list_programs, :list_programs_xml, :next_video, :list_channel_category, :target_video,
        :play_video, 
        :index, :index_koobee, :index_hupo, :index_mepop, 
        :show_ad_top_banner_728x90, :show_ad_square_250x250, 
        :show_ad_top_left_120x90, :show_ad_skyscraper_top_left_120x600, :show_ad_skyscraper_bottom_left_120x600, :show_ad_vertical_left_120x240,
        :show_ad_top_right_120x90, :show_ad_skyscraper_top_right_120x600, :show_ad_skyscraper_bottom_right_120x600, :show_ad_vertical_right_120x240,
        :show_ad_skyscraper_nokia_5800, :show_ad_square_125x125_top_right, :show_ad_rectangle_300x250, :job
         
    # ==================================
    # initialize
    # ==================================
  def initialize
  end
  
    # ==================================
    # index
    # ==================================
  def index
    #@target_program_id = params[:program_id]
        @syndication = Syndication.find($syndication_id)
        
        @new_programs = Program.find(:all, :conditions=>"new_yn='y'", :order => "new_yn_weight, program_id desc", :limit => 16)         
    end
    
    # ==================================
    # index_hd
    # ==================================
  def index_hd
    #@target_program_id = params[:program_id]
        @syndication = Syndication.find($syndication_id)
        
        @new_programs = Program.find(:all, :conditions=>"new_yn='y'", :order => "new_yn_weight, program_id desc", :limit => 16)         
    end

    # ==================================
    # index_mepop
    # ==================================
  def index_mepop
    #@target_program_id = params[:program_id]
        @syndication = Syndication.find($syndication_id)

    @new_programs = Program.find(:all, :conditions=>"new_yn='y'", :order => "new_yn_weight, program_id desc", :limit => 16)         
    end

    # ==================================
    # index_hupo
    # ==================================
  def index_hupo
    #@target_program_id = params[:program_id]
        @syndication = Syndication.find($syndication_id)

    @new_programs = Program.find(:all, :conditions=>"new_yn='y'", :order => "new_yn_weight, program_id desc", :limit => 16)         
    end

    # ==================================
    # index_koobee
    # ==================================
  def index_koobee
    #@target_program_id = params[:program_id]
        @syndication = Syndication.find($syndication_id)

    @new_programs = Program.find(:all, :conditions=>"new_yn='y'", :order => "new_yn_weight, program_id desc", :limit => 16)         
    end

    # ==================================
    # job
    # ==================================
    def job
    end
        
    # ==================================
    # show_ad_top_banner_728x90
    # ==================================
    def show_ad_top_banner_728x90
    @channel_id = params[:id]
    end

    # ==================================
    # show_ad_square_125x125_top_right
    # ==================================
    def show_ad_square_125x125_top_right
    @channel_id = params[:id]
    end

    # ==================================
    # show_ad_rectangle_336x280
    # ==================================
    def show_ad_rectangle_336x280
    @channel_id = params[:id]
    end

    # ==================================
    # show_ad_top_left_120x90
    # ==================================
    def show_ad_top_left_120x90
    @channel_id = params[:id]
    end

    # ====================================
    # show_ad_skyscraper_top_left_120x600
    # ====================================
    def show_ad_skyscraper_top_left_120x600
    @channel_id = params[:id]
    end

    # =======================================
    # show_ad_skyscraper_bottom_left_120x600
    # =======================================
    def show_ad_skyscraper_bottom_left_120x600
    @channel_id = params[:id]
    end

    # =======================================
    # show_ad_vertical_left_120x240
    # =======================================
    def show_ad_vertical_left_120x240
    @channel_id = params[:id]
    end

    # ==================================
    # show_ad_top_right_120x90
    # ==================================
    def show_ad_top_right_120x90
    @channel_id = params[:id]
    end

    # ====================================
    # show_ad_skyscraper_top_right_120x600
    # ====================================
    def show_ad_skyscraper_top_right_120x600
    @channel_id = params[:id]
    end

    # =======================================
    # show_ad_skyscraper_bottom_right_120x600
    # =======================================
    def show_ad_skyscraper_bottom_right_120x600
    @channel_id = params[:id]
    end

    # =======================================
    # show_ad_vertical_right_120x240
    # =======================================
    def show_ad_vertical_right_120x240
    @channel_id = params[:id]
    end

    # =======================================
    # show_ad_rectangle_300x250
    # =======================================
    def show_ad_rectangle_300x250
    @channel_id = params[:id]
    end

    # ==================================
    # list_programs
    # ==================================
  def list_programs
        ids = params[:id]
        if ids != nil
            id_array = ids.split("-")
        end
        
        if id_array != nil && id_array.size > 0         
            @list_type = id_array[0]    
            @channel_id = id_array[1]
            @category_id = id_array[2]
        else
            @list_type = ids
        end

        @keyword = ''
    
    case @list_type
            when 'channel'
                @container_channel = Channel.find(@channel_id.to_i)
        
            when 'parent_category' 
                @container_category = Category.find(@category_id.to_i)
                @container_channel = Channel.findByCategoryId(@category_id.to_i)

        when 'child_category'
            @container_category = Category.find(@category_id.to_i)
                @container_channel = Channel.findByCategoryId(@category_id.to_i)
                        
        when 'new'

            when 'popular'
            
            when 'recommend'

            when 'search'
            @keyword = id_array[1]
            when 'related'
                
        end

        if @channel_id == nil
            @channel_id = ""
        end
        
        if @category_id == nil
            @category_id = ""
        end
  end
 
    # ==================================
    # list_programs_xml
    # ==================================
  def list_programs_xml
        ids = params[:id]
        if ids != nil
            id_array = ids.split("-")
        end
        if id_array != nil && id_array.size > 0         
            @list_type = id_array[0]    
            channel_id = id_array[1]
            category_id = id_array[2]
            sfirst = id_array[3]
            slast = id_array[4]
            
            @first = sfirst.to_i
            @last = slast.to_i

        else
            @list_type = ids
        end

        @parent_category_id = ""
        @keyword = ''
    @note = 'tree'
    
    case @list_type
        when 'channel'
            cat_ids = "-1"
            channel = Channel.find(channel_id)
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
              
            sql = "select p.* from category_program cp, programs p where cp.category_id in (" + cat_ids + ") and cp.program_id = p.program_id order by program_id desc"
            @programs = Program.find_by_sql(sql)
                
            @container_channel = channel
        
        when 'parent_category' 
            @parent_category_id = category_id
            cat_ids = "-1"
            category = Category.find(category_id.to_i)
            subcategorys = category.categorys
            if subcategorys.size > 0
                for subcategory in subcategorys
                    cat_ids += "," + subcategory.category_id.to_s
                end
            else
                cat_ids += "," + category.category_id.to_s
            end
            sql = "select p.* from category_program cp, programs p where cp.category_id in (" + cat_ids + ") and cp.program_id = p.program_id order by program_id desc"
            @programs = Program.find_by_sql(sql)
                
            @container_channel = Channel.findByCategoryId(@parent_category_id.to_i)
            @container_category = category

        when 'child_category'
            category = Category.find(category_id.to_i)
            @programs = category.programs
            
            @container_channel = Channel.findByCategoryId(category_id.to_i)
            @container_category = category
                        
        when 'new'
            @note = 'new'
            @programs = Program.find(:all, :conditions=>"new_yn='y'", :order => "new_yn_weight, program_id desc") 

        when 'new1'
            @note = 'new1'
            @programs = Program.find(:all, :conditions=>"new1_yn='y'", :order => "new1_yn_weight, program_id desc") 

        when 'new2'
            @note = 'new1'
            @programs = Program.find(:all, :conditions=>"new2_yn='y'", :order => "new2_yn_weight, program_id desc") 

        when 'new3'
            @note = 'new1'
            @programs = Program.find(:all, :conditions=>"new3_yn='y'", :order => "new3_yn_weight, program_id desc") 

        when 'new4'
            @note = 'new4'
            @programs = Program.find(:all, :conditions=>"new4_yn='y'", :order => "new4_yn_weight, program_id desc") 

        when 'popular'
                @note = 'popular'
                max_programs = 80
            
                # first find programs that we must include
                conditions = "(xpopular_yn is null or xpopular_yn <> 'y') and ipopular_yn = 'y' and enable_yn = 'y' and enable_start_date <= now() and enable_end_date >= now() "
                order = "ipopular_weight"
                sql = "select * from programs where " + conditions + " order by " + order + " limit " + max_programs.to_s
                included_programs = Program.find_by_sql(sql)

                # find programs that are most popular by viewed
                conditions = "(xpopular_yn is null or xpopular_yn <> 'y') and enable_yn = 'y' and enable_start_date <= now() and enable_end_date >= now() "
                order = "viewed desc"
                sql = "select * from programs where " + conditions + " order by " + order + " limit " + max_programs.to_s


                popular_programs = Program.find_by_sql(sql)

                # build the combined program array
            @programs = []
            for program in included_programs
                @programs << program
                end

                count = @programs.length()
            for program in popular_programs
                    if count >= max_programs 
                        break
                    end 
                @programs << program
                end 
            
            when 'recommend'
                @note = 'recommend'
                @programs = Program.find(:all, :conditions=>"recommend_yn='y' and enable_yn='y' and enable_start_date <= now() and enable_end_date >= now()", :order => "recommend_weight, program_id desc") 

        when 'search'
                @note = 'search'
            @keyword = id_array[1]
            keywords_2ary = cn_analyzer(@keyword)
            programs = Program.find_by_contents(keywords_2ary, :limit=>64)
    
            @programs = []
            for program in programs
                if program.enable_yn == 'y' && program.enable_start_date.to_datetime <= DateTime.now && program.enable_end_date.to_datetime >= DateTime.now && program.channel_id != nil && program.category_id != nil 
                    @programs << program
                end         
                end
                
                @parent_category_id = @keyword
#puts "*** search:" + keywords_2ary + " found:" + @programs.size().to_s

        when 'related'
                @note = 'related'
            relate_program_id = id_array[1]
            relate_program = Program.find(relate_program_id.to_i)
                @parent_category_id = relate_program_id
            
            if relate_program.keywords != nil
                keywords = relate_program.keywords
            else
                keywords = ""
            end

                keywords += " " + relate_program.auto_keywords_3

                keywords = _keywords_insert_or(keywords)
                
            programs = Program.find_by_contents(keywords, :limit=>64)
    
            @programs = []
            for program in programs
                if program.program_id != relate_program_id.to_i && program.enable_yn == 'y' && program.enable_start_date.to_datetime <= DateTime.now && program.enable_end_date.to_datetime >= DateTime.now && program.channel_id != nil && program.category_id != nil 
                    @programs << program
                end         
                end
                
            else
            @programs = Program.find(:all, :conditions=>"new_yn='y'", :order => "new_yn_weight, program_id desc") 
            
        end
    
  end

 
    # ==================================
    # play_video
    # ==================================
  def play_video
        ids = params[:id]
        
        if ids != nil
            id_array = ids.split("-")
        end
        
        if id_array != nil && id_array.size > 1     
            @channel_id = id_array[0]
            @category_id = id_array[1]
            @program_id = id_array[2]
            @video_note = id_array[3]
        end
        
        if @program_id != nil && @program_id != ""
            @program = Program.find(@program_id)
        else
            @program = nil
        end

  end

    # ==================================
    # next_video
    # ==================================
  def next_video
        ids = params[:id]
        if ids != nil
            id_array = ids.split("-")
        end
        
        if id_array != nil && id_array.size > 1         
            @list_type = id_array[0]    
            channel_id = id_array[1]
            category_id = id_array[2]
            program_id = id_array[3]
            @parent_category_id = id_array[4]
        else
            @list_type = ids
        end
        
        @nthumbnails = 3
        @programs = Array.new
        @channel_ids = Array.new
        @category_ids = Array.new

        case @list_type
            when 'channel'
                cat_ids = "-1"
                channel = Channel.find(channel_id.to_i)
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
              
                sql = "select p.* from category_program cp, programs p where cp.category_id in (" + cat_ids + ") and cp.program_id = p.program_id order by program_id desc"
                programs_all = Program.find_by_sql(sql)
                @programs = _get_next_nprograms_circular(program_id.to_i, programs_all, @nthumbnails)   

                for program in @programs 
                    category = Category.findByProgramId(program.program_id)
                    if category != nil
                        cat_id = category.category_id
                        channel = Channel.findByCategoryId(category.category_id)
                        if channel != nil
                            chan_id = channel.channel_id
                        end
                    end
                
                    @channel_ids << chan_id
                    @category_ids << cat_id 
                end

            when 'parent_category'
                cat_ids = "-1"
                category = Category.find(@parent_category_id.to_i)
                subcategorys = category.categorys
                if subcategorys.size > 0
                    for subcategory in subcategorys
                        cat_ids += "," + subcategory.category_id.to_s
                    end
                else
                    cat_ids += "," + category.category_id.to_s
                end
                sql = "select p.* from category_program cp, programs p where cp.category_id in (" + cat_ids + ") and cp.program_id = p.program_id order by program_id desc"
                programs_all = Program.find_by_sql(sql)
                @programs = _get_next_nprograms_circular(program_id.to_i, programs_all, @nthumbnails)   

                for program in @programs 
                    category = Category.findByProgramId(program.program_id)
                    if category != nil
                        cat_id = category.category_id
                        channel = Channel.findByCategoryId(category.category_id)
                        if channel != nil
                            chan_id = channel.channel_id
                        end
                    end
                
                    @channel_ids << chan_id
                    @category_ids << cat_id 
                end

            when 'child_category'
                chan_id = channel_id.to_i
                cat_id = category_id.to_i
                prog_id = program_id.to_i
        
                while @programs.length < @nthumbnails
                    progs = _get_next_nprograms_by_category(cat_id, prog_id, @nthumbnails)
                    @programs = @programs + progs
                
                    for i in 0...progs.length
                        @channel_ids << chan_id
                        @category_ids << cat_id 
                    end
                
                    if @programs.length < @nthumbnails
                        cat_id = _get_next_category(chan_id, cat_id)
                        prog_id = 0

                        while cat_id == 0
                            chan_id = _get_next_channel(chan_id)
                            while chan_id == 0
                                chan_id = _get_next_channel(chan_id)
                            end

                            cat_id = _get_next_category(chan_id, 0)
                        end
                    end
                end

            when 'new'
                if program_id == nil || program_id == '' || program_id == '0'
                    @programs = Program.find(:all, :conditions=>"new_yn='y'", :order => "new_yn_weight, program_id desc") 
                else
                    programs_all = Program.find(:all, :conditions=>"new_yn='y'", :order => "new_yn_weight, program_id desc") 
                    @programs = _get_next_nprograms_circular(program_id.to_i, programs_all, @nthumbnails)   
                end
            
                for program in @programs 
                    category = Category.findByProgramId(program.program_id)
                    if category != nil
                        cat_id = category.category_id
                        channel = Channel.findByCategoryId(category.category_id)
                        if channel != nil
                            chan_id = channel.channel_id
                        end
                    end
                
                    @channel_ids << chan_id
                    @category_ids << cat_id 
                end

            when 'new1'
                if program_id == nil || program_id == '' || program_id == '0'
                    @programs = Program.find(:all, :conditions=>"new1_yn='y'", :order => "new1_yn_weight, program_id desc") 
                else
                    programs_all = Program.find(:all, :conditions=>"new1_yn='y'", :order => "new1_yn_weight, program_id desc") 
                    @programs = _get_next_nprograms_circular(program_id.to_i, programs_all, @nthumbnails)   
                end
            
                for program in @programs 
                    category = Category.findByProgramId(program.program_id)
                    if category != nil
                        cat_id = category.category_id
                        channel = Channel.findByCategoryId(category.category_id)
                        if channel != nil
                            chan_id = channel.channel_id
                        end
                    end
                
                    @channel_ids << chan_id
                    @category_ids << cat_id 
                end
            
            when 'new2'
                if program_id == nil || program_id == '' || program_id == '0'
                    @programs = Program.find(:all, :conditions=>"new2_yn='y'", :order => "new2_yn_weight, program_id desc") 
                else
                    programs_all = Program.find(:all, :conditions=>"new2_yn='y'", :order => "new2_yn_weight, program_id desc") 
                    @programs = _get_next_nprograms_circular(program_id.to_i, programs_all, @nthumbnails)   
                end
            
                for program in @programs 
                    category = Category.findByProgramId(program.program_id)
                    if category != nil
                        cat_id = category.category_id
                        channel = Channel.findByCategoryId(category.category_id)
                        if channel != nil
                            chan_id = channel.channel_id
                        end
                    end
                
                    @channel_ids << chan_id
                    @category_ids << cat_id 
                end

            when 'new3'
                if program_id == nil || program_id == '' || program_id == '0'
                    @programs = Program.find(:all, :conditions=>"new3_yn='y'", :order => "new3_yn_weight, program_id desc") 
                else
                    programs_all = Program.find(:all, :conditions=>"new3_yn='y'", :order => "new3_yn_weight, program_id desc") 
                    @programs = _get_next_nprograms_circular(program_id.to_i, programs_all, @nthumbnails)   
                end
            
                for program in @programs 
                    category = Category.findByProgramId(program.program_id)
                    if category != nil
                        cat_id = category.category_id
                        channel = Channel.findByCategoryId(category.category_id)
                        if channel != nil
                            chan_id = channel.channel_id
                        end
                    end
                
                    @channel_ids << chan_id
                    @category_ids << cat_id 
                end

            when 'new4'
                if program_id == nil || program_id == '' || program_id == '0'
                    @programs = Program.find(:all, :conditions=>"new4_yn='y'", :order => "new4_yn_weight, program_id desc") 
                else
                    programs_all = Program.find(:all, :conditions=>"new4_yn='y'", :order => "new4_yn_weight, program_id desc") 
                    @programs = _get_next_nprograms_circular(program_id.to_i, programs_all, @nthumbnails)   
                end
            
                for program in @programs 
                    category = Category.findByProgramId(program.program_id)
                    if category != nil
                        cat_id = category.category_id
                        channel = Channel.findByCategoryId(category.category_id)
                        if channel != nil
                            chan_id = channel.channel_id
                        end
                    end
                
                    @channel_ids << chan_id
                    @category_ids << cat_id 
                end

            when 'popular'
                max_programs = 80
            
                # first find programs that we must include
                conditions = "(xpopular_yn is null or xpopular_yn <> 'y') and ipopular_yn = 'y' and enable_yn = 'y' and enable_start_date <= now() and enable_end_date >= now() "
                order = "ipopular_weight"
                sql = "select * from programs where " + conditions + " order by " + order + " limit " + max_programs.to_s
                included_programs = Program.find_by_sql(sql)

                # find programs that are most popular by viewed
                conditions = "(xpopular_yn is null or xpopular_yn <> 'y') and enable_yn = 'y' and enable_start_date <= now() and enable_end_date >= now() "
                order = "viewed desc"
                sql = "select * from programs where " + conditions + " order by " + order + " limit " + max_programs.to_s

                popular_programs = Program.find_by_sql(sql)

                # build the combined program array
            programs_all = []
            for program in included_programs
                programs_all << program
                end

                count = @programs.length()
            for program in popular_programs
                    if count >= max_programs 
                        break
                    end 
                programs_all << program
                end 
                
                @programs = _get_next_nprograms_circular(program_id.to_i, programs_all, @nthumbnails)   

          for program in @programs 
                    category = Category.findByProgramId(program.program_id)
                    if category != nil
                        cat_id = category.category_id
                        channel = Channel.findByCategoryId(category.category_id)
                        if channel != nil
                            chan_id = channel.channel_id
                        end
                    end
                
                @channel_ids << chan_id
                @category_ids << cat_id 
                end             
                        
            when 'recommend'
                programs_all = Program.find(:all, :limit=>max_programs, :conditions=>"recommend_yn='y' and enable_yn='y' and enable_start_date <= now() and enable_end_date >= now()", :order => "recommend_weight, program_id desc") 
            
                @programs = _get_next_nprograms_circular(program_id.to_i, programs_all, @nthumbnails)   

          for program in @programs 
                    category = Category.findByProgramId(program.program_id)
                    if category != nil
                        cat_id = category.category_id
                        channel = Channel.findByCategoryId(category.category_id)
                        if channel != nil
                            chan_id = channel.channel_id
                        end
                    end
                
                @channel_ids << chan_id
                @category_ids << cat_id 
                end             

            when 'search'
            keywords = @parent_category_id
            keywords_2ary = cn_analyzer(keywords)
                programs = Program.find_by_contents(keywords_2ary, :limit=>64)

            programs_all = []
            for program in programs
                if program.enable_yn == 'y' && program.enable_start_date.to_datetime <= DateTime.now && program.enable_end_date.to_datetime >= DateTime.now && program.channel_id != nil && program.category_id != nil 
                    programs_all << program
                end         
                end

                @programs = _get_next_nprograms_circular(program_id.to_i, programs_all, @nthumbnails)   
            
          for program in @programs 
                    category = Category.findByProgramId(program.program_id)
                    if category != nil
                        cat_id = category.category_id
                        channel = Channel.findByCategoryId(category.category_id)
                        if channel != nil
                            chan_id = channel.channel_id
                        end
                    end
                
                @channel_ids << chan_id
                @category_ids << cat_id 
                end

            when 'related'
            relate_program = Program.find(@parent_category_id.to_i)
            
            if relate_program.keywords != nil
                keywords = relate_program.keywords
            else
                keywords = ""
            end

                keywords += " " + relate_program.auto_keywords_3

                keywords = _keywords_insert_or(keywords)

            programs = Program.find_by_contents(keywords, :limit=>64)
    
            programs_all = []
            for program in programs
                if program.program_id != relate_program.program_id && program.enable_yn == 'y' && program.enable_start_date.to_datetime <= DateTime.now && program.enable_end_date.to_datetime >= DateTime.now && program.channel_id != nil && program.category_id != nil 
                    programs_all << program
                end         
                end

                @programs = _get_next_nprograms_circular(program_id.to_i, programs_all, @nthumbnails)   
            
          for program in @programs 
                    category = Category.findByProgramId(program.program_id)
                    if category != nil
                        cat_id = category.category_id
                        channel = Channel.findByCategoryId(category.category_id)
                        if channel != nil
                            chan_id = channel.channel_id
                        end
                    end
                
                @channel_ids << chan_id
                @category_ids << cat_id 
                end

            else    
        end
                
    end
  
    # ==================================
    # target_video
    # ==================================
  def target_video
        @target_program_id = params[:id]
    end

    # ==================================
    # video_config
    # ==================================
    def video_config
        ids = params[:id]
        if ids != nil
            id_array = ids.split("-")
            if id_array != nil && id_array.size > 1     
                @channel_id  = id_array[0]
                @category_id = id_array[1]
                @program_id  = id_array[2]
                @video_note  = id_array[3]
                @mode        = id_array[4]
                @ad_id       = id_array[5]
            end
        else
                @channel_id  = params[:channelId]
                @category_id = params[:categoryId]
                @program_id  = params[:programId]
                @video_note  = params[:videoNote]
                @mode        = params[:mode]
                @ad_id       = params[:ad]
        end

        @mode = "local" if @mode == nil
                    
    # mode can be 'remote' means it is embedded in an outside webpage
    if @mode != nil && @mode == 'remote'
        @base_url = $base_url
    else
        @base_url = ''
    end

    # Get cached program    
    if @program_id
            #@program = Cache.get('program-' + @program_id)
            #if @program == nil
          @program = Program.find(@program_id)
            #   Cache.put('program-' + @program_id, @program)
            #end
    else
      @program = nil
    end

    if (@ad_id == nil || @ad_id == '' || !@ad_id.match(/\A[0-9]+\Z/) )
            all_ads = Ad.find :all
            @ad = all_ads[rand(all_ads.size)]   
    else
        begin
                @ad = Ad.find(@ad_id.to_i)
        rescue
                puts "**** error: invalid ad id in mogo_controller:video_config: " + @ad_id
                all_ads = Ad.find :all
                @ad = all_ads[rand(all_ads.size)]               
        end
    end

    if cookies[:uniqueid] == nil
        cookie_value = Time.now.to_i.to_s + rand(10000).to_s
        cookies[:uniqueid] = { :value => cookie_value , :expires => Time.now + 5000.day}
        # p "new cookie " + cookie_value
    else
        cookie_value = cookies[:uniqueid]
    end

    VideoLog.new do |v|
        #v.user_ip = request.env['REMOTE_HOST']
        v.user_ip = request.remote_ip().to_s
        v.user_unique_id = cookie_value
        v.program_id = @program_id
        v.channel_id = @channel_id
        v.category_id = @category_id
        v.ad_id = @ad.id
        v.note = @video_note
        v.syndication_id = $syndication_id
        v.created = Time.now
        v.save
    end


    end
      
    # ==================================
    # search_programs
    # ==================================
  def search_programs
    query = params[:query]
    query = cn_analyzer(query)
    programs = Program.find_by_contents(query, :limit=>50)
    
    @programs_found = []
    for program in programs
        if program.enable_yn == 'y' && program.enable_start_date.to_datetime <= DateTime.now && program.enable_end_date.to_datetime >= DateTime.now && program.channel_id != nil && program.category_id != nil 
            @programs_found << program
        end
    end
  end
  
    # ==================================
    # search_name
    # ==================================
    def search_name
        query = params[:query]
        query = cn_analyzer(query)
        programs = Program.find_by_contents(query, :limit=>100)
        @programs_found = []
        for program in programs
            if program.enable_yn == 'y' && program.enable_start_date.to_datetime <= DateTime.now && program.enable_end_date.to_datetime >= DateTime.now && program.channel_id != nil && program.category_id != nil 
                @programs_found << program
            end
        end
        
   end

    # ==================================
    # say_time
    # ==================================
    def say_time
    render_text "<p>The time is <b>" + DateTime.now.to_s + "</b></p>"
  end

    # ==================================
    # embed_video
    # ==================================
  def embed_video
    @channel_id = params[:channelId]
    @category_id = params[:categoryId]
        @program = Program.find(params[:programId])
        
        if @category_id == nil
            @category = Category.findByProgramId(@program.program_id)
            if @category != nil
                @category_id = @category.category_id.to_s
                @channel = Channel.findByCategoryId(@category.category_id)
                if @channel != nil
                    @channel_id = @channel.channel_id.to_s
                end
            end
        end
    end

    # ==================================
    # private
    # ==================================
    private
    
    # ==================================
    # _get_next_nprograms_circular
    # ==================================
  def _get_next_nprograms_circular(program_id, programs, n)
    next_programs = Array.new
 
        if program_id == 0
            is_next_program = true
        else
        is_next_program = false
    end
    pos = 0
    count = 0
    lastpos = programs.length() -1
    
    while true  
            if next_programs.length() >= n || count >= (programs.length() + n)
                break
            end
            
        if is_next_program
            next_programs << programs[pos]
        end
        
        if programs[pos].program_id == program_id
            is_next_program = true
        end

            pos += 1
            count += 1

        if pos > lastpos
            pos = 0
        end
    end

    return next_programs
  end

    # ==================================
    # _get_next_nprograms_by_category
    # ==================================
  def _get_next_nprograms_by_category(category_id, program_id, n)
    category = Category.find(category_id)
    programs = category.programs
    next_programs = Array.new
    count = 0
    
    if program_id == 0
        is_next_program = true
    else
        is_next_program = false
    end
    
    for program in programs
        if is_next_program && count < n
            next_programs << program
            count += 1
        end
        if program.program_id == program_id
            is_next_program = true
        end
    end
    
    return next_programs
  end

    # ==================================
    # _get_next_category
    # ==================================
  def _get_next_category(channel_id, category_id)
        channel = Channel.find(channel_id)
        categorys = channel.categorys
        if category_id == 0
            is_next_category = true
        else
            is_next_category = false
        end
        
        for category in categorys 
            subcategorys = category.categorys
            if subcategorys.size > 0
              for subcategory in subcategorys
                if is_next_category
                    return subcategory.category_id
                end
                    if subcategory.category_id == category_id
                        is_next_category = true
                    end
              end
            else
            if is_next_category
                return category.category_id
            end
                if category.category_id == category_id
                    is_next_category = true
                end
            end
        end
        
        return 0
    end

    # ==================================
    # _get_next_channel
    # ==================================
  def _get_next_channel(channel_id)
    channels = Channel.find(:all, :conditions=> "channel_id <> 8", :order => :weight)

        if channel_id == 0
            is_next_channel = true
        else
            is_next_channel = false
        end
        
        for channel in channels
            if is_next_channel
                return channel.channel_id
            end
            
            if channel.channel_id == channel_id
                is_next_channel = true
            end
        end
  
    return 0
    end     
    
    # ==================================
    # _keywords_insert_or
    # ==================================
  def _keywords_insert_or(keywords)
    return "" if keywords == nil
    
    words = keywords.split(' ')
    
    new_keywords = ""
    for word in words
        if new_keywords == ""
            new_keywords = word
        else
            new_keywords = new_keywords + " OR " + word
        end
    end 
    
    return new_keywords
    end
    
    
end
