class AdminController < ApplicationController
  require 'find2'
  require 'cn_analyzer'
  require 'cnip'

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

    layout 'admin', :except => [:index, :frame_left, :frame_center, :get_video_file_select_options, 
        :get_channel_category_link_select_options, :get_category_category_link_select_options, :get_category_program_link_select_options,    
        :get_video_thumb_file_select_options, :get_video_thumb_dir_select2_options, :show_stats_year_xml, :show_stats_month_xml, 
        :show_stats_day_xml, :show_stats_channel_xml, :show_stats_location_xml, :edit_category, :edit_category_from_channel, :edit_program,
        :show_program, :show_program_brief, :destroy_program, :destroy_category_program, :play_program, :thumb_program]

  before_filter :authorize, :except => [:show_stats_year_xml, :show_stats_month_xml, 
        :show_stats_day_xml, :show_stats_channel_xml, :show_stats_location_xml]

    # ==================================
    # index
    # ==================================
    def index
    end

    # ==================================
    # ----------------------------------
    # channel methods
    # ----------------------------------
    # ==================================

    # ==================================
    # list_channels
    # ==================================
    def list_channels
    @all_channels = Channel.find(:all, :order => :weight)
    end

    # ==================================
    # show_channel
    # ==================================
  def show_channel
    @channel = Channel.find(params[:id])
  end

    # ==================================
    # new_channel
    # ==================================
  def new_channel
    @channel = Channel.new
  end

    # ==================================
    # create_channel
    # ==================================
  def create_channel
        attributes = params[:channel]
        #if params['channel_icon_select'].length > 0
        #   attributes['channel_icon'] = params['channel_icon_select']  
        #end
    
        #if params['channel_small_select'].length > 0
        #   attributes['channel_small'] = params['channel_small_select']
        #end

    @channel = Channel.new(attributes)

    if @channel.save
      flash[:notice] = 'Channel was successfully created.'
      redirect_to :action => 'show_channel', :id => @channel
    else
      render :action => 'new_channel'
    end
  end

    # ==================================
    # edit_channel
    # ==================================
  def edit_channel
    @channel = Channel.find(params[:id])
  end

    # ==================================
    # update_channel
    # ==================================
  def update_channel
    @channel = Channel.find(params[:id])

        # save uploaded file - channel_icon
        #if params['channel_icon_file'].length > 0
        #   incoming_file = params['channel_icon_file']     
        #   base_file_name = sanitize_filename(incoming_file.original_filename)
        #   @channel.channel_icon = "images/channels/channel_" + Time.now.to_i.to_s + "_" + base_file_name    
        #   File.open("#{RAILS_ROOT}/public/#{@channel.channel_icon}", "wb") do |f| 
        #               f.write(incoming_file.read)
        #   end 
        #end
        
        attributes = params[:channel]
    

    if @channel.update_attributes(attributes)
      flash[:notice] = 'Channel was successfully updated.'
      redirect_to :action => 'show_channel', :id => @channel
    else
      render :action => 'edit_channel'
    end
  end

    # ==================================
    # destroy_channel
    # ==================================
  def destroy_channel
        channel_categorys = ChannelCategory.find(:all, :conditions => "channel_id = " + params[:id])
        for channel_category in channel_categorys
            channel_category.destroy
        end

    Channel.find(params[:id]).destroy
    redirect_to :action => 'list_channels'
  end

    # ==================================
    # update_channel_weights
    # ==================================
  def update_channel_weights
    params[:weight].each {|key, value|
        channel = Channel.find(key)
        channel.update_attributes({:weight=>value})
    }
    redirect_to :action => 'list_channels'
  end
 
    # ==================================
    # ----------------------------------
    # channel_category methods
    # ----------------------------------
    # ==================================

    # ==================================
    # create_channel_category
    # ==================================
  def create_channel_category
    channel_category = ChannelCategory.new(params[:channel_category])

    if channel_category.save
      flash[:notice] = 'Channel category was successfully created.'
    end

    redirect_to :action => 'show_channel', :id => channel_category.channel_id
  end

    # ==================================
    # update_channel_category_weights
    # ==================================
  def update_channel_category_weights
    channel_id = params[:channel_id]
    params[:weight].each {|key, value|
        channel_category = ChannelCategory.find(:first, :conditions => { :channel_id => channel_id, :category_id => key })
        channel_category.update_attributes({:weight=>value})
    }
    redirect_to :action => 'show_channel', :id => channel_id
  end

    # ==================================
    # destroy_channel_category
    # ==================================
  def destroy_channel_category
    channel_id = params[:channel_id]
    category_id = params[:category_id]
        channel_category = ChannelCategory.find(:first, :conditions => { :channel_id => channel_id, :category_id => category_id })
    channel_category.destroy
    redirect_to :action => 'show_channel', :id => channel_id
  end

    # ========================================
    # get_channel_category_link_select_options
    # ========================================
    def get_channel_category_link_select_options
    channel_id = params[:channel_id]

        @list = []

        #build a list of all categories
        list = []
        categories = Category.find(:all, :order => "category_name_cn")
        for category in categories
            list << [category.category_name_cn, category.id]
        end

        #remove from the list already linked in categories
        
        # show all unlinked categories
        if channel_id == "unlinked"
            channel_categories = ChannelCategory.find(:all)
            category_categories = CategoryCategory.find(:all)

            for channel_category in channel_categories
                list.delete_if {|x| x[1] == channel_category.category_id}
            end

            for category_category in category_categories
                list.delete_if {|x| x[1] == category_category.child_category_id}
            end

        else
            channel_categories = []
        end     

        for item in list
            @list << '<option value="' + item[1].to_s + '">' + item[0] + '</option>'            
        end
    
        return @list
    end

    # ==================================
    # ----------------------------------
    # category methods
    # ----------------------------------
    # ==================================

    
    # ==================================
    # list_categorys
    # ==================================
    def list_categorys
    @all_categorys = Category.find(:all, :order => :category_name_cn)
    end
    
    # ==================================
    # list_not_linked_to_channel_categorys
    # ==================================
    def list_not_linked_to_channel_categorys
    categorys = Category.find(:all)
    
    @all_categorys = []
puts "list_not_linked_to_channel_categorys"    
    for category in categorys
        chancats = ChannelCategory.find(:all, :conditions => "category_id = " + category.id.to_s)
        if chancats == nil || chancats.size() == 0
 puts "cat:" + category.id.to_s
            catcats = CategoryCategory.find(:all, :conditions => "child_category_id = " + category.category_id.to_s)
            
            if catcats == nil || catcats.size() == 0 
                @all_categorys << category
            else
                for catcat in catcats
                    chancats = ChannelCategory.find(:all, :conditions => "category_id = " + catcat.parent_category_id.to_s)
                    if chancats == nil || chancats.size() == 0
                        @all_categorys << category
                    end     
                end
            end
            
        end     
        
    end
    end
    
    # ==================================
    # show_category
    # ==================================
  def show_category
    @category = Category.find(params[:id])
  end

    # ==================================
    # new_category
    # ==================================
  def new_category
    @category = Category.new
  end

    # ==================================
    # create_category
    # ==================================
  def create_category
    @category = Category.new(params[:category])
    if @category.save
      flash[:notice] = 'Category was successfully created.'
      redirect_to :action => 'show_category', :id => @category
    else
      render :action => 'new_category'
    end
  end

    # ==================================
    # edit_category
    # ==================================
  def edit_category
    @category = Category.find(params[:id])
  end

    # ==================================
    # edit_category_from_channel
    # ==================================
  def edit_category_from_channel
    @channel = Channel.find(params[:channel_id])
    @category = Category.find(params[:category_id])
  end

    # ==================================
    # update_category
    # ==================================
  def update_category
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      flash[:notice] = 'Category was successfully updated.'
      redirect_to :action => 'edit_category', :id => @category
    else
      render :action => 'edit_category'
    end
  end

    # ==================================
    # update_category_from_channel
    # ==================================
  def update_category_from_channel
    channel_id = params[:channel_id]
    @category = Category.find(params[:category_id])
    
    if @category.update_attributes(params[:category])
      flash[:notice] = 'Category was successfully updated.'
      redirect_to :action => 'edit_category_from_channel', :channel_id => channel_id, :category_id => @category
    else
      render :action => 'edit_category_from_channel'
    end
  end

    # ==================================
    # destroy_category
    # ==================================
  def destroy_category
        channel_categorys = ChannelCategory.find(:all, :conditions => "category_id = " + params[:id])
        for channel_category in channel_categorys
            channel_category.destroy
        end
        
        category_categorys = CategoryCategory.find(:all, :conditions => "parent_category_id = " + params[:id])
        for category_category in category_categorys
            category_category.destroy
        end
        
        category_categorys = CategoryCategory.find(:all, :conditions => "child_category_id = " + params[:id])
        for category_category in category_categorys
            category_category.destroy
        end

        category_programs = CategoryProgram.find(:all, :conditions => "category_id = " + params[:id])
        for category_program in category_programs
            category_program.destroy
        end
                        
    Category.find(params[:id]).destroy

    redirect_to :action => 'list_categorys'    
  end

    # ==================================
    # ----------------------------------
    # category_category methods
    # ----------------------------------
    # ==================================

    # ==================================
    # create_category_category
    # ==================================
  def create_category_category
    category_category = CategoryCategory.new(params[:category_category])

    if category_category.save
      flash[:notice] = 'Channel category was successfully created.'
    end

    redirect_to :action => 'show_category', :id => category_category.parent_category_id
  end

    # ==================================
    # update_category_category_weights
    # ==================================
  def update_category_category_weights
    parent_category_id = params[:parent_category_id]
    params[:weight].each {|key, value|
        category_category = CategoryCategory.find(:first, :conditions => { :parent_category_id => parent_category_id, :child_category_id => key })
        category_category.update_attributes({:weight=>value})
    }
    redirect_to :action => 'show_category', :id => parent_category_id
  end

    # ==================================
    # destroy_category_category
    # ==================================
  def destroy_category_category
    parent_category_id = params[:parent_category_id]
    child_category_id = params[:child_category_id]
        category_category = CategoryCategory.find(:first, :conditions => { :parent_category_id => parent_category_id, :child_category_id => child_category_id })
    category_category.destroy
    redirect_to :action => 'show_category', :id => parent_category_id
  end

    # ==================================
    # ----------------------------------
    # category_program methods
    # ----------------------------------
    # ==================================

    # ==================================
    # create_category_program
    # ==================================
  def create_category_program
    category_program = CategoryProgram.new(params[:category_program])

    if category_program.save
      flash[:notice] = 'Category program was successfully created.'
    end

    redirect_to :action => 'show_category', :id => category_program.category_id
  end

    # ========================
    # update_category_programs
    # ========================
  def update_category_programs
    category_id = params[:category_id]

        #enable_yn_checkboxes = params[:enable_yn]
        new_yn_checkboxes = params[:new_yn]
        ipopular_yn_checkboxes = params[:ipopular_yn]
        xpopular_yn_checkboxes = params[:xpopular_yn]
        recommend_yn_checkboxes = params[:recommend_yn]
    
    params[:weight].each {|key, value|
        category_program = CategoryProgram.find(:first, :conditions => { :category_id => category_id, :program_id => key })
        category_program.update_attributes({:weight=>value})
        
        program = Program.find(key)

        #if enable_yn_checkboxes != nil && enable_yn_checkboxes[key] != nil
        #   program.update_attributes({:enable_yn=>"y"})
            #else
        #   program.update_attributes({:enable_yn=>"n"})
            #end

        if new_yn_checkboxes != nil && new_yn_checkboxes[key] != nil
            program.update_attributes({:new_yn=>"y"})
            else
            program.update_attributes({:new_yn=>"n"})
            end

        if ipopular_yn_checkboxes != nil && ipopular_yn_checkboxes[key] != nil
            program.update_attributes({:ipopular_yn=>"y"})
            else
            program.update_attributes({:ipopular_yn=>"n"})
            end

        if xpopular_yn_checkboxes != nil && xpopular_yn_checkboxes[key] != nil
            program.update_attributes({:xpopular_yn=>"y"})
            else
            program.update_attributes({:xpopular_yn=>"n"})
            end

        if recommend_yn_checkboxes != nil && recommend_yn_checkboxes[key] != nil
            program.update_attributes({:recommend_yn=>"y"})
            else
            program.update_attributes({:recommend_yn=>"n"})
            end
    }

    redirect_to :action => 'show_category', :id => category_id
  end

    # ==================================
    # destroy_category_program
    # ==================================
  def destroy_category_program
    @program_id = params[:program_id] 
    category_id = params[:category_id]
    program_id = params[:program_id]
        category_program = CategoryProgram.find(:first, :conditions => { :category_id => category_id, :program_id => program_id })
    category_program.destroy
  end

    # ========================================
    # get_category_category_link_select_options
    # ========================================
    def get_category_category_link_select_options
    channel_id = params[:channel_id]

        @list = []

        #build a list of all categories
        list = []
        categories = Category.find(:all, :order => "category_name_cn")
        for category in categories
            list << [category.category_name_cn, category.id]
        end

        #remove from the list already linked in categories
        
        # show all unlinked categories
        if channel_id == "unlinked"
            channel_categories = ChannelCategory.find(:all)
            category_categories = CategoryCategory.find(:all)

            for channel_category in channel_categories
                list.delete_if {|x| x[1] == channel_category.category_id}
            end

            for category_category in category_categories
                list.delete_if {|x| x[1] == category_category.child_category_id}
            end

        else
            channel_categories = []
        end     

        for item in list
            @list << '<option value="' + item[1].to_s + '">' + item[0] + '</option>'            
        end
    
        return @list
    end

    # ========================================
    # get_category_program_link_select_options
    # ========================================
    def get_category_program_link_select_options
    category_id = params[:category_id]

        @list = []

        if category_id == '-1'
            return @list
        end
        
        if category_id == "0"
            sql = "select * from programs p where p.program_id not in (select program_id from category_program)"
            programs = Program.find_by_sql(sql)

            for program in programs
                @list << '<option value="' + program.id.to_s + '">' + program.program_name_cn + '</option>'             
            end
            return @list
        end

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

        for item in list
            @list << '<option value="' + item[1].to_s + '">' + item[0] + '</option>'            
        end
    
        return @list
    end

    # ==================================
    # ----------------------------------
    # program methods
    # ----------------------------------
    # ==================================

    # ==================================
    # list_programs
    # ==================================
    def list_programs
    @channel_id = params[:channel_id]
        @order_type = params[:order_type]
        @limit = params[:limit]
        @keyword = params[:keyword]
    @all_programs = []
    @all_channels = Channel.find(:all, :order => :weight)

        conditions = "1=1"
        conditions2 = nil
        limit = 1000000
        
        limit = @limit.to_i if @limit != 'all'
        
        if @keyword != nil && @keyword != ''
        keywords_2ary = cn_analyzer(@keyword)
        programs = Program.find_by_contents(keywords_2ary, :limit=>limit)
        for program in programs
            if program.enable_yn == 'y' && program.enable_start_date.to_datetime <= DateTime.now && program.enable_end_date.to_datetime >= DateTime.now && program.channel_id != nil && program.category_id != nil 
                @all_programs << program
            end         
            end
            return
        end
        
        if @order_type == "by_date"
            order = "program_id DESC"
        elsif @order_type == "by_name"
            order = "program_name_cn"           
        elsif @order_type == "by_new"
            conditions = "new_yn = 'y'"
            order = "new_yn_weight"
        elsif @order_type == "by_new1"
            conditions = "new1_yn = 'y'"
            order = "new1_yn_weight"
        elsif @order_type == "by_new2"
            conditions = "new2_yn = 'y'"
            order = "new2_yn_weight"
        elsif @order_type == "by_new3"
            conditions = "new3_yn = 'y'"
            order = "new3_yn_weight"
        elsif @order_type == "by_new4"
            conditions = "new4_yn = 'y'"
            order = "new4_yn_weight"
        elsif @order_type == "by_viewed"
            order = "viewed DESC"
        elsif @order_type == "by_popular"
            conditions = "popular_yn = 'y'"
            order = "popular_weight"            
        elsif @order_type == "by_recommend"
            conditions = "recommend_yn = 'y'"            
            order = "recommend_weight"
        elsif @order_type == "by_top10"
            conditions = "((xpopular_yn is null or xpopular_yn <> 'y') and ipopular_yn = 'y') "          
            order = "ipopular_weight limit 10"

            conditions2 = "(xpopular_yn is null or xpopular_yn <> 'y') "             
            order2 = "viewed DESC limit 10"
        
            limit = 10
        elsif @order_type == "by_include"
            conditions = "ipopular_yn = 'y'"             
            order = "ipopular_weight"
        elsif @order_type == "by_exclude"
            conditions = "xpopular_yn = 'y'"             
            order = "program_id DESC"
        elsif @order_type == "by_disabled"
            conditions = "enable_yn <> 'y'"          
            order = "program_id DESC"
        elsif @order_type == "by_loaded_to_youku_not_checked"
            conditions = "(youku_id is not null and youku_id <> '') and (youku_ok_yn is null or youku_ok_yn = '' or youku_ok_yn = 'n')"          
            order = "youku_uploaded_dt DESC"
        elsif @order_type == "by_loaded_to_youku_checked"
            conditions = "(youku_id is not null and youku_id <> '') and youku_ok_yn = 'y'"
            order = "youku_uploaded_dt DESC"
        elsif @order_type == "by_not_loaded_to_youku"
            conditions = "(youku_id is null or youku_id = '')"           
            order = "program_id DESC"
        elsif @order_type == "by_loaded_to_koobee"
            conditions = "(koobee_uploaded_dt is not null and koobee_uploaded_dt <> '')"
            order = "koobee_uploaded_dt DESC"
        elsif @order_type == "by_not_loaded_to_koobee"
            conditions = "(koobee_uploaded_dt is null or koobee_uploaded_dt = '')"           
            order = "program_id DESC"
        end

        if @order_type != "by_unlinked"
            if @channel_id != nil && @channel_id.size > 0
                if @channel_id == "all"                 
                    @all_programs = Program.find(:all, :conditions => conditions, :order => order, :limit => limit)
                elsif @channel_id == "with_external_id"
                    conditions = conditions + " and (external_id is not null and external_id <> '')"
                    @all_programs = Program.find(:all, :conditions => conditions, :order => order, :limit => limit)
                elsif @channel_id == "without_external_id"
                    conditions = conditions + " and (external_id is null or external_id = '')"
                    @all_programs = Program.find(:all, :conditions => conditions, :order => order, :limit => limit)
                else
                    # *** get programs by channel id ***
                  channel = Channel.find(@channel_id)
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
                 
                    sql = "select p.* from category_program cp, programs p where cp.category_id in (" + cat_ids + ") and cp.program_id = p.program_id and " + conditions + " order by " + order
                    programs = Program.find_by_sql(sql)

                    count = 0
                    for program in programs 
                        if count >= limit
                            break
                        end
                        @all_programs << program
                        count += 1
                    end

                    if conditions2 != nil
                        sql = "select p.* from category_program cp, programs p where cp.category_id in (" + cat_ids + ") and cp.program_id = p.program_id and " + conditions2 + " order by " + order2
                        programs = Program.find_by_sql(sql)

                        for program in programs 
                            if count >= limit
                                break
                            end
                            @all_programs << program
                            count += 1
                        end
                    end
                end
            else
                @all_programs = nil
            end
        else # unlinked programs
            @list = []

            #build a list of all programs
            list = []
            programs = Program.find(:all)
            for program in programs
                list << [program.program_name_cn, program.id]
            end

            #remove from the list already linked in programs
            category_programs = CategoryProgram.find(:all)
        
            for category_program in category_programs
                list.delete_if {|x| x[1] == category_program.program_id}
            end

            condition = ""
            for item in list
                if condition == ""
                    condition = item[1].to_s
                else
                    condition += ", " + item[1].to_s
                end
            end
    
            if condition != ""
                condition = "program_id IN (" + condition + ")"
            end 
        
            @all_programs = Program.find(:all, :conditions=>condition, :limit => limit)
        end

    end
    
    # ==================================
    # list_unlinked_programs
    # ==================================
    def list_unlinked_programs
        @list = []

        #build a list of all programs
        list = []
        programs = Program.find(:all)
        for program in programs
            list << [program.program_name_cn, program.id]
        end

        #remove from the list already linked in programs
        category_programs = CategoryProgram.find(:all)
        
        for category_program in category_programs
            list.delete_if {|x| x[1] == category_program.program_id}
        end

        condition = ""
        for item in list
            if condition == ""
                condition = item[1].to_s
            else
                condition += ", " + item[1].to_s
            end
        end
    
        if condition != ""
            condition = "program_id IN (" + condition + ")"
        end 
        
        @all_unlinked_programs = Program.find(:all, :conditions=>condition)
    end

    # ==================================
    # list_new_programs
    # ==================================
    def list_new_programs
            @all_new_programs = Program.find(:all, :conditions=>"new_yn='y'", :order => "new_yn_weight, program_id desc")
    end
    
    # ==================================
    # list_new1_programs
    # ==================================
    def list_new1_programs
            @all_new_programs = Program.find(:all, :conditions=>"new1_yn='y'", :order => "new1_yn_weight, program_id desc")
    end
    
    # ==================================
    # list_new2_programs
    # ==================================
    def list_new2_programs
            @all_new_programs = Program.find(:all, :conditions=>"new2_yn='y'", :order => "new2_yn_weight, program_id desc")
    end
    
    # ==================================
    # list_new3_programs
    # ==================================
    def list_new3_programs
            @all_new_programs = Program.find(:all, :conditions=>"new3_yn='y'", :order => "new3_yn_weight, program_id desc")
    end
    
    # ==================================
    # list_new4_programs
    # ==================================
    def list_new4_programs
            @all_new_programs = Program.find(:all, :conditions=>"new4_yn='y'", :order => "new4_yn_weight, program_id desc")
    end

    # ==================================
    # list_recommended_programs
    # ==================================
    def list_recommended_programs
            @all_recommend_programs = Program.find(:all, :conditions=>"recommend_yn='y'", :order => "recommend_weight, program_id desc")
    end
    
    # ==================================
    # list_coming_programs
    # ==================================
    def list_coming_programs
    @all_coming_programs = Program.find(:all, :order => :program_name_cn, :conditions => "enable_start_date >= now()")
    end

    # ==================================
    # list_expired_programs
    # ==================================
    def list_expired_programs
    @all_expired_programs = Program.find(:all, :order => :program_name_cn, :conditions => "enable_end_date < now()")
    end

    # ==================================
    # list_disabled_programs
    # ==================================
    def list_disabled_programs
    @all_disabled_programs = Program.find(:all, :order => :program_name_cn, :conditions => "enable_yn <> 'y'")
    end

    # ==================================
    # show_program
    # ==================================
  def show_program
    @program = Program.find(params[:id])
  end

    # ==================================
    # show_program_brief
    # ==================================
  def show_program_brief
    @program = Program.find(params[:id])
  end

    # ==================================
    # thumb_program
    # ==================================
  def thumb_program
    @program = Program.find(params[:id])
  end

    # ==================================
    # play_program
    # ==================================
  def play_program
    @program = Program.find(params[:id])
    @source = params[:source]
  end

    # ==================================
    # new_program
    # ==================================
  def new_program
    @program = Program.new
    
    @program.enable_yn = 'y'
  end

    # ==================================
    # create_program
    # ==================================
  def create_program
        attributes = params[:program]
        
        if params['program_path_stream_dir_select'].length > 0 && params['program_path_stream_file_select'].length > 0
            dir = params['program_path_stream_dir_select'].sub($path_video_root,"")
            if dir[0,1] == "/"
                dir.sub!("/", "")
                video_path = dir + "/" + params['program_path_stream_file_select']
            else
                video_path = params['program_path_stream_file_select']          
            end         
            attributes['program_path_stream'] = video_path
        end 
        
        if params['program_icon_dir_select2'].length > 0 && params['program_icon_file_select'].length > 0
            dir = params['program_icon_dir_select2'].sub($path_video_thumb_root,"")
            if dir[0,1] == "/"
                dir.sub!("/", "")
                video_thumb_path = dir + "/" + params['program_icon_file_select']
            else
                video_thumb_path = params['program_icon_file_select']           
            end         
            attributes['program_icon'] =     video_thumb_path
        end 
    
        if params['program_enable_start_date'] == nil || params['program_enable_start_date'].length == 0
            attributes['enable_start_date'] = '2000-01-01'
        else
            attributes['enable_start_date'] = params['program_enable_start_date']
        end 

        if params['program_enable_end_date'] == nil || params['program_enable_end_date'].length == 0
            attributes['enable_end_date'] = '2020-01-01'
        else
            attributes['enable_end_date'] = params['program_enable_end_date']
        end 

        attributes['created'] = Time.now

    @program = Program.new(attributes)
    
    if @program.save
      flash[:notice] = 'Program was successfully created.'
      redirect_to :action => 'show_program', :id => @program
    else
      render :action => 'new_program'
    end
  end

    # ==================================
    # edit_program
    # ==================================
  def edit_program
    @program = Program.find(params[:id])
  end

    # ==================================
    # update_program
    # ==================================
  def update_program
    @program = Program.find(params[:id])

        attributes = params[:program]

        if params['program_path_stream_dir_select'] != nil && params['program_path_stream_dir_select'].length > 0 && 
             params['program_path_stream_file_select'] != nil && params['program_path_stream_file_select'].length > 0
            dir = params['program_path_stream_dir_select'].sub($path_video_root,"")
            if dir[0,1] == "/"
                dir.sub!("/", "")
                video_path = dir + "/" + params['program_path_stream_file_select']
            else
                video_path = params['program_path_stream_file_select']          
            end         
            attributes['program_path_stream'] = video_path
        end 
        
        if params['program_icon_file_select'] != nil && params['program_icon_file_select'].length && params['program_icon_file_select'] != "-- select a file --"
            dir = params['program_icon_dir_select2'].sub($path_video_thumb_root,"")
            if dir[0,1] == "/"
                dir.sub!("/", "")
                video_thumb_path = dir + "/" + params['program_icon_file_select']
            else
                video_thumb_path = params['program_icon_file_select']           
            end         
            attributes['program_icon'] =     video_thumb_path
        end 

        if params['program_enable_start_date'] == nil || params['program_enable_start_date'].length == 0
            attributes['enable_start_date'] = '2000-01-01'
        else
            attributes['enable_start_date'] = params['program_enable_start_date']
        end 

        if params['program_enable_end_date'] == nil || params['program_enable_end_date'].length == 0
            attributes['enable_end_date'] = '2020-01-01'
        else
            attributes['enable_end_date'] = params['program_enable_end_date']
        end 

   if @program.update_attributes(attributes)
      flash[:notice] = 'Program was successfully updated.'
      redirect_to :action => 'edit_program', :id => @program
    else
      render :action => 'edit_program'
    end
  end

    # ========================
    # update_program_list
    # ========================
    def update_program_list
        channel_id = params[:channel_id]
        order_type = params[:order_type]

        #enable_yn_checkboxes = params[:enable_yn]
        new_yn_checkboxes = params[:new_yn]
        new1_yn_checkboxes = params[:new1_yn]
        new2_yn_checkboxes = params[:new2_yn]
        new3_yn_checkboxes = params[:new3_yn]
        new4_yn_checkboxes = params[:new4_yn]

        recommend_yn_checkboxes = params[:recommend_yn]
        ipopular_yn_checkboxes = params[:ipopular_yn]
        xpopular_yn_checkboxes = params[:xpopular_yn]

        params[:new_yn_weight].each {|key, value|
            program = Program.find(key)
            program.update_attributes({:new_yn_weight=>value}) unless program.new_yn_weight == value
            if new_yn_checkboxes != nil && new_yn_checkboxes[key] != nil
                program.update_attributes({:new_yn=>"y"}) unless program.new_yn == "y"
            else
                program.update_attributes({:new_yn=>"n"}) unless program.new_yn == "n"
            end

            if xpopular_yn_checkboxes != nil && xpopular_yn_checkboxes[key] != nil
                program.update_attributes({:xpopular_yn=>"y"}) unless program.xpopular_yn == "y"
            else
                program.update_attributes({:xpopular_yn=>"n"}) unless program.xpopular_yn == "n"
            end
        }

        params[:new1_yn_weight].each {|key, value|
            program = Program.find(key)
            program.update_attributes({:new1_yn_weight=>value}) unless program.new1_yn_weight == value
            if new1_yn_checkboxes != nil && new1_yn_checkboxes[key] != nil
                program.update_attributes({:new1_yn=>"y"}) unless program.new1_yn == "y"
            else
                program.update_attributes({:new1_yn=>"n"}) unless program.new1_yn == "n"
            end
        }

        params[:new2_yn_weight].each {|key, value|
            program = Program.find(key)
            program.update_attributes({:new2_yn_weight=>value}) unless program.new2_yn_weight == value
            if new2_yn_checkboxes != nil && new2_yn_checkboxes[key] != nil
                program.update_attributes({:new2_yn=>"y"}) unless program.new2_yn == "y"
            else
                program.update_attributes({:new2_yn=>"n"}) unless program.new2_yn == "n"
            end
        }

        params[:new3_yn_weight].each {|key, value|
            program = Program.find(key)
            program.update_attributes({:new3_yn_weight=>value}) unless program.new3_yn_weight == value
            if new3_yn_checkboxes != nil && new3_yn_checkboxes[key] != nil
                program.update_attributes({:new3_yn=>"y"}) unless program.new3_yn == "y"
            else
                program.update_attributes({:new3_yn=>"n"}) unless program.new3_yn == "n"
            end
        }

        params[:new4_yn_weight].each {|key, value|
            program = Program.find(key)
            program.update_attributes({:new4_yn_weight=>value}) unless program.new4_yn_weight == value
            if new4_yn_checkboxes != nil && new4_yn_checkboxes[key] != nil
                program.update_attributes({:new4_yn=>"y"}) unless program.new4_yn == "y"
            else
                program.update_attributes({:new4_yn=>"n"}) unless program.new4_yn == "n"
            end
        }

        params[:ipopular_weight].each {|key, value|
            program = Program.find(key)
            program.update_attributes({:ipopular_weight=>value}) unless program.ipopular_weight == value

            if ipopular_yn_checkboxes != nil && ipopular_yn_checkboxes[key] != nil
                    program.update_attributes({:ipopular_yn=>"y"}) unless program.ipopular_yn == "y"
            else
                program.update_attributes({:ipopular_yn=>"n"}) unless program.ipopular_yn == "n"
            end
        }
        
        params[:recommend_weight].each {|key, value|
            program = Program.find(key)
            program.update_attributes({:recommend_weight=>value}) unless program.recommend_weight == value

            if recommend_yn_checkboxes != nil && recommend_yn_checkboxes[key] != nil
                    program.update_attributes({:recommend_yn=>"y"}) unless program.recommend_yn == "y"
            else
                program.update_attributes({:recommend_yn=>"n"}) unless program.recommend_yn == "n"
            end
        }

    redirect_to :action => 'list_programs', :channel_id => channel_id, :order_type => order_type

  end

    # ==================================
    # destroy_program
    # ==================================
  def destroy_program
    @program_id = params[:id] 

        category_programs = CategoryProgram.find(:all, :conditions => "program_id = " + params[:id])
        for category_program in category_programs
            category_program.destroy
        end
                        
    Program.find(params[:id]).destroy
  end
  
    # ==================================
    # generate_program_thumbnails
    # ==================================
    def generate_program_thumbnails
        @program = Program.find(params[:id])
        
        basename = File.basename(@program.program_path_stream)
        basename.sub!(/\.flv/, '')
        
        video_path = $path_mogo + "/" + $path_video_root + "/" + @program.program_path_stream
        
        thumb_path = $path_mogo + "/" + $path_video_thumb_root + "/tmp/" + basename + "_thumb1.jpg"
        _generate_thumbnail(video_path, thumb_path, 45)
        thumb_path = $path_mogo + "/" + $path_video_thumb_root + "/tmp/" + basename + "_thumb2.jpg"
        _generate_thumbnail(video_path, thumb_path, 47)
        thumb_path = $path_mogo + "/" + $path_video_thumb_root + "/tmp/" + basename + "_thumb3.jpg"
        _generate_thumbnail(video_path, thumb_path, 49)
        thumb_path = $path_mogo + "/" + $path_video_thumb_root + "/tmp/" + basename + "_thumb4.jpg"
        _generate_thumbnail(video_path, thumb_path, 51)
        thumb_path = $path_mogo + "/" + $path_video_thumb_root + "/tmp/" + basename + "_thumb5.jpg"
        _generate_thumbnail(video_path, thumb_path, 53)
        thumb_path = $path_mogo + "/" + $path_video_thumb_root + "/tmp/" + basename + "_thumb6.jpg"
        _generate_thumbnail(video_path, thumb_path, 55)
        thumb_path = $path_mogo + "/" + $path_video_thumb_root + "/tmp/" + basename + "_thumb7.jpg"
        _generate_thumbnail(video_path, thumb_path, 57)
        thumb_path = $path_mogo + "/" + $path_video_thumb_root + "/tmp/" + basename + "_thumb8.jpg"
        _generate_thumbnail(video_path, thumb_path, 59)
        thumb_path = $path_mogo + "/" + $path_video_thumb_root + "/tmp/" + basename + "_thumb9.jpg"
        _generate_thumbnail(video_path, thumb_path, 61)
        
        flash[:notice] = 'Thumbnails generated. '
        redirect_to :action => 'thumb_program', :id => @program
    end  
    
    def _generate_thumbnail(video_path, thumb_path, offset)
        command = "export LD_LIBRARY_PATH=/usr/local/lib/"
        command = command + " && " + "ffmpeg  -itsoffset -#{offset.to_s}  -i \"#{video_path}\" -vcodec mjpeg -vframes 1 -an -f rawvideo -s 128x96 \"#{thumb_path}\" "
  
        IO.popen("echo `date`: generate thumb >> /tmp/generate_thumb.log")
        #IO.popen("echo `rm -rf \"#{thumb_path}\"` >> /tmp/generate_thumb.log")
        IO.popen("echo `#{command}` >> /tmp/generate_thumb.log")
    end
    
    # ==================================
    # update_program_thumbnail
    # ==================================
    def update_program_thumbnail
        @program = Program.find(params[:id])

        if  params['program_thumb'] == nil || 
            params['program_thumb'].length == 0 || 
            params['program_thumb'] == "-- click on a thumbnail --"
            flash[:notice] = 'Thumbnail not updated. Please click on a thumbnail'
            redirect_to :action => 'thumb_program', :id => @program
           return
        end

        physical_thumb_path_src = $path_mogo + "/" + $path_video_thumb_root + "/tmp/" + params['program_thumb_src']
        physical_thumb_path_dst = $path_mogo + "/" + $path_video_thumb_root + "/all/" + params['program_thumb_src']
        program_icon = "all/" + params['program_thumb_src']

        command = "rm -rf \"#{physical_thumb_path_dst}\""
        IO.popen("echo `#{command}`")
        command = "cp \"#{physical_thumb_path_src}\" \"#{physical_thumb_path_dst}\""
        IO.popen("echo `#{command}`")

        @program.update_attributes({:program_icon=>program_icon})

        flash[:notice] = 'Thumbnail updated ' 
        redirect_to :action => 'thumb_program', :id => @program
    end

    # ==================================
    # ----------------------------------
    # ad methods
    # ----------------------------------
    # ==================================

    # ==================================
    # list_ads
    # ==================================
    def list_ads
    @all_ads = Ad.find(:all, :order => :ad_name)
    end

    # ==================================
    # show_ad
    # ==================================
  def show_ad
    @ad = Ad.find(params[:id])
  end

    # ==================================
    # new_ad
    # ==================================
  def new_ad
    @ad = Ad.new
  end

    # ==================================
    # create_ad
    # ==================================
  def create_ad
        attributes = params[:ad]
        if params['ad_flv_video_select'].length > 0
            attributes['ad_flv_video'] = params['ad_flv_video_select']  
        end
    
    @ad = Ad.new(attributes)

    if @ad.save
      flash[:notice] = 'Ad was successfully created.'
      redirect_to :action => 'show_ad', :id => @ad
    else
      render :action => 'new_ad'
    end
  end

    # ==================================
    # edit_ad
    # ==================================
  def edit_ad
    @ad = Ad.find(params[:id])
  end

    # ==================================
    # update_ad
    # ==================================
  def update_ad
    @ad = Ad.find(params[:id])

        attributes = params[:ad]
        
        if params['ad_flv_video_select'].length > 0
            attributes['ad_flv_video'] = params['ad_flv_video_select']  
        end
    
    if @ad.update_attributes(attributes)
      flash[:notice] = 'Ad was successfully updated.'
      redirect_to :action => 'show_ad', :id => @ad
    else
      render :action => 'edit_ad'
    end
  end

    # ==================================
    # destroy_ad
    # ==================================
  def destroy_ad
    Ad.find(params[:id]).destroy
    redirect_to :action => 'list_ads'
  end

    # ==================================
    # ----------------------------------
    # partner methods
    # ----------------------------------
    # ==================================

    # ==================================
    # list_partners
    # ==================================
    def list_partners
    @all_partners = Partner.find(:all, :order => :weight)
    end

    # ==================================
    # show_partner
    # ==================================
  def show_partner
    @partner = Partner.find(params[:id])
  end

    # ==================================
    # new_partner
    # ==================================
  def new_partner
    @partner = Partner.new
  end

    # ==================================
    # create_partner
    # ==================================
  def create_partner
        attributes = params[:partner]
        
        if params['partner_logo_select'] != nil && params['partner_logo_select'].length > 0
            attributes['logo'] = params['partner_logo_select']  
        end
    
    @partner = Partner.new(attributes)
    
    if @partner.save
      flash[:notice] = 'Partner was successfully created.'
      redirect_to :action => 'show_partner', :id => @partner
    else
      render :action => 'new_partner'
    end
  end

    # ==================================
    # edit_partner
    # ==================================
  def edit_partner
    @partner = Partner.find(params[:id])
  end

    # ==================================
    # update_partner
    # ==================================
  def update_partner
    @partner = Partner.find(params[:id])

        attributes = params[:partner]
        if params['partner_logo_select'] != nil && params['partner_logo_select'].length > 0
            attributes['logo'] = params['partner_logo_select']  
        end
    
    if @partner.update_attributes(attributes)
      flash[:notice] = 'Partner was successfully updated.'
      redirect_to :action => 'show_partner', :id => @partner
    else
      render :action => 'edit_partner'
    end
  end

    # ==================================
    # destroy_partner
    # ==================================
  def destroy_partner
    Partner.find(params[:id]).destroy
    redirect_to :action => 'list_partners'
  end

    # ==================================
    # update_partner_weights
    # ==================================
  def update_partner_weights
    params[:weight].each {|key, value|
        partner = Partner.find(key)
        partner.update_attributes({:weight=>value})
    }
    redirect_to :action => 'list_partners'
  end
 
    # ==================================
    # ----------------------------------
    # syndication methods
    # ----------------------------------
    # ==================================

    # ==================================
    # list_syndications
    # ==================================
    def list_syndications
     @all_syndications = Syndication.find(:all, :order => :name)
    end
 
    # ==================================
    # show_syndication
    # ==================================
  def show_syndication
     @syndication = Syndication.find(params[:id])
  end
 
    # ==================================
    # new_syndication
    # ==================================
  def new_syndication
     @syndication = Syndication.new
  end
 
    # ==================================
    # create_syndication
    # ==================================
  def create_syndication
        attributes = params[:syndication]
     
    @syndication = Syndication.new(attributes)
 
    if @syndication.save
       flash[:notice] = 'Syndication was successfully created.'
       redirect_to :action => 'show_syndication', :id => @syndication
     else
       render :action => 'new_syndication'
     end
   end
 
    # ==================================
    # edit_syndication
    # ==================================
   def edit_syndication
     @syndication = Syndication.find(params[:id])
   end
 
    # ==================================
    # update_syndication
    # ==================================
  def update_syndication
     @syndication = Syndication.find(params[:id])
 
        attributes = params[:syndication]
        
    if @syndication.update_attributes(attributes)
       flash[:notice] = 'Syndication was successfully updated.'
       redirect_to :action => 'show_syndication', :id => @syndication
    else
       render :action => 'edit_syndication'
    end
  end

    # ==================================
    # destroy_syndication
    # ==================================
   def destroy_syndication
     Syndication.find(params[:id]).destroy
     redirect_to :action => 'list_syndications'
   end
 

    # ==================================
    # list_logs
    # ==================================
    def list_logs
        @start_date = params['start_date']
        @end_date = params['end_date']
        @query_type = params['query_type']

        condition = ""
        if @start_date != nil && @end_date != nil 
            condition = " where created >= '" + @start_date + " 00:00' and created <= '" + @end_date + " 23:59'"
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
                    @logs = VideoLogArchive.find_by_sql(sql)
            else
                    sql = "SELECT channel_id, category_id, program_id, count(program_id) program_count FROM video_log " +
                    condition + " group by channel_id, category_id, program_id "
                    @logs = VideoLog.find_by_sql(sql)
                end

                # *** type: tree ***
            if query_archive
                    sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'tree'"
                    result = VideoLogArchive.find_by_sql(sql)
                else
                    sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'tree'"
                    result = VideoLog.find_by_sql(sql)
                end
                @count_tree = result[0].count

                # *** type: auto ***
            if query_archive
                    sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'auto'"
                    result = VideoLogArchive.find_by_sql(sql)
                else
                    sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'auto'"
                    result = VideoLog.find_by_sql(sql)
                end
                @count_auto = result[0].count

                # *** type: friend ***
            if query_archive
                    sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'friend'"
                    result = VideoLogArchive.find_by_sql(sql)
                else
                    sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'friend'"
                    result = VideoLog.find_by_sql(sql)
                end
                @count_friend = result[0].count

                # *** type: next ***
            if query_archive
                    sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'next'"
                    result = VideoLogArchive.find_by_sql(sql)
                else
                    sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'next'"
                    result = VideoLog.find_by_sql(sql)
                end
                @count_next = result[0].count

                # *** type: first ***
            if query_archive
                    sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'first'"
                    result = VideoLogArchive.find_by_sql(sql)
                else
                    sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'first'"
                    result = VideoLog.find_by_sql(sql)
                end
                @count_first = result[0].count

                # *** type: search ***
            if query_archive
                    sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'search'"
                    result = VideoLogArchive.find_by_sql(sql)
                else
                    sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'search'"
                    result = VideoLog.find_by_sql(sql)
                end
                @count_search = result[0].count

                # *** type: new ***
            if query_archive
                    sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'new'"
                    result = VideoLogArchive.find_by_sql(sql)
                else
                    sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'new'"
                    result = VideoLog.find_by_sql(sql)
                end 
                @count_new = result[0].count

                # *** type: embed ***
            if query_archive
                    sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'embed'"
                    result = VideoLogArchive.find_by_sql(sql)
                else
                    sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'embed'"
                    result = VideoLog.find_by_sql(sql)
                end
                @count_embed = result[0].count


                # *** type: recommend ***
                sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'recommend'"
            if query_archive
                    sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'recommend'"
                    result = VideoLogArchive.find_by_sql(sql)
                else
                    sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'recommend'"
                    result = VideoLog.find_by_sql(sql)
                end
                @count_recommend = result[0].count


                # *** type: popular ***
            if query_archive
                    sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'popular'"
                    result = VideoLogArchive.find_by_sql(sql)
                else
                    sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'popular'"
                    result = VideoLog.find_by_sql(sql)
                end
                @count_popular = result[0].count

                # *** type: related ***
            if query_archive
                    sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND note = 'related'"
                    result = VideoLogArchive.find_by_sql(sql)
                else
                    sql = "SELECT count(*) count FROM video_log " + condition + " AND note = 'related'"
                    result = VideoLog.find_by_sql(sql)
                end
                @count_related = result[0].count

                # *** type: other ***
            if query_archive
                    sql = "SELECT count(*) count FROM video_log_archive " + condition + " AND (note is null OR note = '')"
                    result = VideoLogArchive.find_by_sql(sql)
                else
                    sql = "SELECT count(*) count FROM video_log " + condition + " AND (note is null OR note = '')"
                    result = VideoLog.find_by_sql(sql)
                end
                @count_null = result[0].count
            else
            if query_archive
                    sql = "SELECT channel_id, category_id, program_id, count(distinct user_unique_id) user_count FROM video_log_archive " +
                    condition + " group by channel_id, category_id, program_id "
                    @logs = VideoLogArchive.find_by_sql(sql)
                else
                    sql = "SELECT channel_id, category_id, program_id, count(distinct user_unique_id) user_count FROM video_log " +
                    condition + " group by channel_id, category_id, program_id "
                    @logs = VideoLog.find_by_sql(sql)
                end

            if query_archive
                    sql2 = "SELECT count(distinct user_unique_id) users FROM video_log_archive " + condition
                    result = VideoLogArchive.find_by_sql(sql2)
                else
                    sql2 = "SELECT count(distinct user_unique_id) users FROM video_log " + condition
                    result = VideoLog.find_by_sql(sql2)
                end
                @unique_users = result[0].users
            end

      end   
    end

    # ==================================
    # list_old_logs
    # ==================================
    def list_old_logs
        @start_date = params['start_date']
        @end_date = params['end_date']

        condition = ""
        if @start_date != nil && @end_date != nil 
            condition = " where logger_time >= '" + @start_date + "' and logger_time <= '" + @end_date + "'"
        end

        if condition != ""
         @logs = VideoLogOld.find_by_sql "SELECT logger_channel_id, logger_category_id, logger_program_id, count(logger_program_id) program_count FROM logger " +
         condition + " group by logger_channel_id, logger_category_id, logger_program_id "
      end   
    end

    # ==================================
    # list_video_recommendations
    # ==================================
    def list_video_recommendations
        @start_date = params['start_date']
        @end_date = params['end_date']
        @query_type = params['query_type']

        condition = ""
        if @start_date != nil && @end_date != nil 
            condition = " where created >= '" + @start_date + " 00:00' and created <= '" + @end_date + " 23:59'"
        end

        if condition != ""
            if @query_type == "all"
                sql = "SELECT id, user_name, user_email, to_email, program_id, comment, created, sent_yn FROM mogolocal.program_recommends " +
                condition + " order by created desc "
                @program_recommends = ProgramRecommend.find_by_sql(sql)

            elsif @query_type == "unsent_email"
                sql = "SELECT id, user_name, user_email, to_email, program_id, comment, created, sent_yn FROM mogolocal.program_recommends " +
                condition + " and (sent_yn is null or sent_yn = '') order by created desc "
                @program_recommends = ProgramRecommend.find_by_sql(sql)
            
            elsif @query_type == "sent_email"
                sql = "SELECT id, user_name, user_email, to_email, program_id, comment, created, sent_yn FROM mogolocal.program_recommends " +
                condition + " and sent_yn = 'y' order by created desc "
                @program_recommends = ProgramRecommend.find_by_sql(sql)
            end

      end   
    end

    # ==================================
    # destroy_video_recommendation
    # ==================================
  def destroy_video_recommendation
    ProgramRecommend.find(params[:id]).destroy
    redirect_to :action => 'list_video_recommendations'
  end


    # ==================================
    # get_video_file_select_options
    # ==================================
  def get_video_file_select_options
        @files = []

        dir = params["dir"]     
        Find2.find({"follow" => true}, dir) do |path|
            if !FileTest.directory?(path)
                basename = File.basename(path) 
                @files << basename  unless basename[0,1] == "." 
            end 
        end
        
        @files.sort!

  end

    # ====================================
    # get_video_thumb_dir_select2_options
    # ====================================
  def get_video_thumb_dir_select2_options
        dir = params["dir"]
        filter = /.*/
        @list = []

        Find2.find({"follow" => false}, dir) do |path|
            if FileTest.directory?(path) && path =~ filter
                    dirname = path.sub(dir,"")
                    if dirname[0,1] == "/"
                        dirname.sub!("/", "")
                    end
                    dirvalue = dir + "/" + dirname
                    if dirname.size > 0 && !(dirname =~ /\./) 
                        @list << "<option value='" + dirvalue + "'>" + dirname + "</option>"
                    end
                end 
        end
            @list.sort!
            return @list
  end

    # ==================================
    # get_video_thumb_file_select_options
    # ==================================
  def get_video_thumb_file_select_options
        @files = []

        dir = params["dir"]     
        Find2.find({"follow" => true}, dir) do |path|
            if !FileTest.directory?(path)
                basename = File.basename(path) 
                @files << basename  unless basename[0,1] == "." 
            end 
        end
        
        @files.sort!

  end

  # ==================================
    # analyzer_test
    # ==================================
  def analyzer_test
        @words = cn_analyzer(params["testfield"])
  end

  # ==================================
    # program_index
    # ==================================
  def program_index
    all_programs = Program.find(:all)
    auto_tags = ""
    
    @count = 0
    for program in all_programs
            category = Category.findByProgramId(program.program_id)
            channel = nil
            channel_id = nil            
            category_id = nil
            if category != nil
                category_id = category.category_id
                channel = Channel.findByCategoryId(category_id)
            end

            if channel != nil
                channel_id = channel.channel_id
            end
            
            if program.keywords != nil && program.keywords != ""
                keywords_array = program.keywords.split(" ")
                count = 0
                limit = 7
                auto_keywords_1 = ""
                auto_keywords_2 = ""
                for keyword in keywords_array
                    if count <= limit
                        auto_keywords_1 += " " + keyword
                    else
                        auto_keywords_2 += " " + keyword
                    end
                    count += 1
                end
            else
                auto_keywords_1 = ""
                auto_keywords_2 = ""
            end
            
            auto_keywords_3 = cn_analyzer(program.program_name_cn.gsub("'", "")) + " " unless program.program_name_cn == nil
            auto_keywords_4 = cn_analyzer(auto_keywords_1)
            auto_keywords_5 = cn_analyzer(auto_keywords_2)
            
        program.update_attributes(:channel_id => channel_id, :category_id => category_id, 
            :auto_keywords_1 => auto_keywords_1,
            :auto_keywords_2 => auto_keywords_2,
            :auto_keywords_3 => auto_keywords_3,
            :auto_keywords_4 => auto_keywords_4,
            :auto_keywords_5 => auto_keywords_5
            )
        
        @count+=1
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

            stats = VideoLogCnc.find_by_sql(sql)
            #stats = VideoLogCt.find_by_sql(sql)

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
            
            @message += "Synchronized with file: " + sync_file
        else
            @message += "Nothing to sync."
        end
  end
  
  # ==================================
    # dump_db
    # ==================================
  def dump_db
        IO.popen($dump_master_cmd + " > " +  $path_dbsync + "/mogo.sql." + Time.now.to_i.to_s)
  end
  
    # ==================================
    # ----------------------------------
    # stats methods
    # ----------------------------------
    # ==================================
    
  # ==================================
    # show_stats
    # ==================================
    def show_stats
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
            
            sum_year = VideoLogSummaryYear.find(:first, :conditions=>"year=" + @year.to_s + " and syndication_id=" + @syndication_id.to_s)
            @parent_id = sum_year.id unless sum_year == nil
            
        elsif (month_s != "all" && day_s == "all")
            @graph_unit = "month"
            @year = year_s.to_i
            @month = month_s.to_i
            
            sum_month = VideoLogSummaryMonth.find(:first, :conditions=>"year=" + @year.to_s + " and month=" + @month.to_s + " and syndication_id=" + @syndication_id.to_s)
            @parent_id = sum_month.id unless sum_month == nil

        elsif (month_s != "all" && day_s != "all")
            @graph_unit = "day"
            @year = year_s.to_i
            @month = month_s.to_i
            @day = day_s.to_i

            sum_day = VideoLogSummaryDay.find(:first, :conditions=>"year=" + @year.to_s + " and month=" + @month.to_s + " and day=" + @day.to_s + " and syndication_id=" + @syndication_id.to_s)
            @parent_id = sum_day.id unless sum_day == nil
        end
        
        @graph_unit = "unknown" if @parent_id == nil 

        if @parent_id != nil
            @sum_programs_by_count = VideoLogSummaryProgram.find(:all, :conditions=>"parent_id=" + @parent_id.to_s, :order=>"count desc")
            @sum_programs_by_unique_users = VideoLogSummaryProgram.find(:all, :conditions=>"parent_id=" + @parent_id.to_s, :order=>"unique_users desc")
        end

        @syndications = Syndication.find(:all)
    end

  # ==================================
    # show_stats_year_xml
    # ==================================
    def show_stats_year_xml
        @year = params[:year].to_i
        @syndication_id = params[:syndication_id].to_i
        @sum_months = VideoLogSummaryMonth.find(:all, :conditions=>"year=" + @year.to_s + " and syndication_id=" + @syndication_id.to_s, :order=>"year, month")
    end
    
  # ==================================
    # show_stats_month_xml
    # ==================================
    def show_stats_month_xml
        @year = params[:year].to_i
        @month = params[:month].to_i
        @syndication_id = params[:syndication_id].to_i
        @sum_days = VideoLogSummaryDay.find(:all, :conditions=>"year=" + @year.to_s + " and month=" + @month.to_s + " and syndication_id=" + @syndication_id.to_s, :order=>"year, month, day")
    end

  # ==================================
    # show_stats_day_xml
    # ==================================
    def show_stats_day_xml
        @year = params[:year].to_i
        @month = params[:month].to_i
        @day = params[:day].to_i
        @syndication_id = params[:syndication_id].to_i
        @sum_hours = VideoLogSummaryHour.find(:all, :conditions=>"year=" + @year.to_s + " and month=" + @month.to_s + " and day=" + @day.to_s + " and syndication_id=" + @syndication_id.to_s, :order=>"year, month, day, hour")
    end

  # ==================================
    # show_stats_channel_xml
    # ==================================
    def show_stats_channel_xml
        parent_id = params[:parent_id].to_i
        sum_channels = VideoLogSummaryChannel.find(:all, :conditions=>"parent_id=" + parent_id.to_s)
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
    # show_stats_location_xml
    # ==================================
    def show_stats_location_xml
        parent_id = params[:parent_id].to_i
        sum_locations = VideoLogSummaryLocation.find(:all, :conditions=>"parent_id=" + parent_id.to_s)
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
    # ----------------------------------
    # private methods
    # ----------------------------------
    # ==================================
    private

    # ==================================
    # sanitize_filename
    # ==================================
    def sanitize_filename(file_name)
    # get only the filename, not the whole path (from IE)
    just_filename = File.basename(file_name) 
    # replace all non-alphanumeric, underscore or periods with underscores
    just_filename.gsub(/[^\w\.\-]/,'_') 
  end   

end
