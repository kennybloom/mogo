class LoginController < ApplicationController
	layout 'admin', :except => [:login]

	def index
		redirect_to "/admin"
	end

  def login
    session[:user_id] = nil
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user && (user.role == "admin" || user.role == "editor")
        session[:user_id] = user.id
        session[:role] = user.role
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || "/admin")
      else
        flash[:notice] = "Invalid user/password combination"
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => "login" )
  end

  def add_user
    @user = User.new(params[:user])
    if request.post? and @user.save
      flash.now[:notice] = "User #{@user.user_name} created"
      @user = User.new
    end
  end

  def list_users
    @all_users = User.find(:all)
  end

  def delete_user
    if request.post?
      user = User.find(params[:id])
      begin
        user.destroy
        flash[:notice] = "User #{user.name} deleted"
      rescue Exception => e
        flash[:notice] = e.message
      end
    end
    redirect_to(:action => :list_users)
  end

end
