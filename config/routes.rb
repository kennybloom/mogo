ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "mogo"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'

  map.connect 'mogo/show_channel/:id',
		:controller => 'mogo',
		:action => 'show_channel',
		:requirements => { :id => /\d+/},
    :id => nil
    
  map.connect 'mogo/show_channel_set_focus/:ids',
  	:controller => 'mogo',
  	:action => 'show_channel_set_focus',
    :ids => nil
    
  map.connect 'mogo/playlist/:id/:category_id/:program_id',
  	:controller => 'mogo',
  	:action => 'playlist',
    :id => nil,
    :category_id => nil,
    :program_id => nil
  	
  map.connect 'mogo/list_programs/:ids',
  	:controller => 'mogo',
  	:action => 'list_programs',
    :ids => nil
  	
   map.connect 'mogo/list_programs_xml/:ids',
  	:controller => 'mogo',
  	:action => 'list_programs_xml',
    :ids => nil
  	
   map.connect 'xml/list_programs_xml/:ids',
  	:controller => 'xml',
  	:action => 'list_programs_xml',
    :ids => nil
  	
	 map.connect 'mogo/next_video/:ids',
  	:controller => 'mogo',
  	:action => 'next_video',
    :ids => nil
  	
  map.connect 'mogo/play_video/:ids',
  	:controller => 'mogo',
  	:action => 'play_video',
    :ids => nil
    
  map.connect 'mogo/playlist/:ids',
  	:controller => 'mogo',
  	:action => 'playlist',
    :ids => nil

  map.connect 'mogo/load_video/:id',
		:controller => 'mogo',
		:action => 'load_video',
		:requirements => { :id => /\d+/},
    :id => nil
    
  map.connect 'mogo/target_video/:id',
		:controller => 'mogo',
		:action => 'target_video',
		:requirements => { :id => /\d+/},
    :id => nil


	# advertisements
  map.connect 'mogo/show_ad_top_banner_728x90/:id',
  	:controller => 'mogo',
  	:action => 'show_ad_top_banner_728x90',
    :id => nil

  map.connect 'mogo/show_ad_square_250x250/:id',
  	:controller => 'mogo',
  	:action => 'show_ad_square_250x250',
    :id => nil

  map.connect 'mogo/show_ad_rectangle_336x280/:id',
  	:controller => 'mogo',
  	:action => 'show_ad_rectangle_336x280',
    :id => nil

  # left ads
  map.connect 'mogo/show_ad_top_left_120x90/:id',
  	:controller => 'mogo',
  	:action => 'show_ad_top_left_120x90',
    :id => nil

  map.connect 'mogo/show_ad_skyscraper_top_left_120x600/:id',
  	:controller => 'mogo',
  	:action => 'show_ad_skyscraper_top_left_120x600',
    :id => nil

  map.connect 'mogo/show_ad_skyscraper_bottom_left_120x600/:id',
  	:controller => 'mogo',
  	:action => 'show_ad_skyscraper_bottom_left_120x600',
    :id => nil

  map.connect 'mogo/show_ad_vertical_left_120x240/:id',
  	:controller => 'mogo',
  	:action => 'show_ad_vertical_left_120x240',
    :id => nil

  # right ads
  map.connect 'mogo/show_ad_top_right_120x90/:id',
  	:controller => 'mogo',
  	:action => 'show_ad_top_right_120x90',
    :id => nil

  map.connect 'mogo/show_ad_skyscraper_top_right_120x600/:id',
  	:controller => 'mogo',
  	:action => 'show_ad_skyscraper_top_right_120x600',
    :id => nil

  map.connect 'mogo/show_ad_skyscraper_bottom_right_120x600/:id',
  	:controller => 'mogo',
  	:action => 'show_ad_skyscraper_bottom_right_120x600',
    :id => nil

  map.connect 'mogo/show_ad_vertical_right_120x240/:id',
  	:controller => 'mogo',
  	:action => 'show_ad_vertical_right_120x240',
    :id => nil
    
  map.connect 'admin/show_stats_month_xml/:year/:month/:syndication_id',
    :controller => 'admin',
    :action => 'show_stats_month_xml',
    :year => nil,
    :month => nil,
    :syndication_id => nil
  
  map.connect 'admin/show_stats_day_xml/:year/:month/:day/:syndication_id',
    :controller => 'admin',
    :action => 'show_stats_day_xml',
    :year => nil,
    :month => nil,
    :day => nil,
    :syndication_id => nil

  map.connect 'stats/show_stats_month_xml/:year/:month',
    :controller => 'stats',
    :action => 'show_stats_month_xml',
    :year => nil,
    :month => nil
        
  map.connect 'stats/show_stats_day_xml/:year/:month/:day',
    :controller => 'stats',
    :action => 'show_stats_day_xml',
    :year => nil,
    :month => nil,
    :day => nil

  map.connect 'stats/show_stats_month_all_xml/:year/:month/:syndication_id',
    :controller => 'stats',
    :action => 'show_stats_month_all_xml',
    :year => nil,
    :month => nil,
    :syndication_id => nil
  
  map.connect 'stats/show_stats_day_all_xml/:year/:month/:day/:syndication_id',
    :controller => 'stats',
    :action => 'show_stats_day_all_xml',
    :year => nil,
    :month => nil,
    :day => nil,
    :syndication_id => nil

end
