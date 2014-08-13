# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  # session :session_key => '_mogo-rails_session_id'
  
  require 'rubygems'
  require 'composite_primary_keys'
  
	ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
		:default => "%m/%d/%Y",
		:date_time12 => "%m/%d/%Y %I:%M%p",
		:date_time24 => "%m/%d/%Y %H:%M",
		:cn => "%Y年%m月%d日 %H点%M分"
	)     

private
  
  def authorize
  	user_id = session[:user_id]
		role = session[:role]
    unless user_id != nil && User.find(user_id) && (role == "admin" || role == "editor")
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in"
      redirect_to(:controller => "login" , :action => "login" )
    end
  end  

  def stats_authorize
  	user_id = session[:user_id]
    unless user_id != nil && User.find(user_id)
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in"
      redirect_to(:controller => "stats_login" , :action => "login" )
    end
  end  
end

