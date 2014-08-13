# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.14' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]
  #config.frameworks -= [ :action_web_service ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store
	config.action_controller.session = { :session_key => "_session", :secret => "some secret phrase of at least 30 characters" }


  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
end

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below

require 'composite_primary_keys'
require 'acts_as_ferret'

my_formats = {
  :my_date_format => '%Y-%m-%d'
}

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(my_formats)
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(my_formats)

ActionMailer::Base.delivery_method = :sendmail

ActionMailer::Base.raise_delivery_errors = true


# =============================
# syndication configuration
# =============================

$syndication_id = 1
$portal_id = 0
$base_url = "http://localhost:3000"
$index_action = ""
$path_mogo	 = "/home/cloud/applications/mogo"
$google_analytics_acct = "UA-2590283-1"
$server_ip = "127.0.0.1"

# =============================
# misc configuration
# =============================
$path_video_root = "public/video"
$path_video_thumb_root = "public/video/Graphics/Program Thumbs"
$path_video = "/video"
$dir_graphics = "Graphics"
$path_channel_icon = "/video/Graphics/Channel Icons"
$path_program_icon = "/video/Graphics/Program Thumbs"
$path_host_icon = "/video/Graphics/Hosts"
$path_partner_logo = "/video/Graphics/Partner Logos"
$path_sponsor_logo = "/video/Graphics/Sponsor Logos"	
$path_billboard_image = "/video/Graphics/Ads Billboard"	
$path_ad_video = "/video/Ads Video"
$path_ad_web = "/video/Graphics/Web Ads"
$path_dbsync = "/home/cloud/applications/mogo/db/sync"

$dump_master_cmd = "mysqldump -h127.0.0.1 -uroot mogo2"
$sync_slave_cmd = "mysql -h127.0.0.1 -uroot mogo2"

# =============================
# memcache stuff
# =============================
#require 'cached_model'

#memcache_options = {
#  :c_threshold => 10_000,
#  :compression => true,
#  :debug => false,
#  :namespace => 'mogo',
#  :readonly => false,
#  :urlencode => false
#}

#CACHE = MemCache.new memcache_options
#CACHE.servers = 'localhost:4000'

ActiveRecord::Base.verification_timeout = 14400