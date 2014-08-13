class StatsLoginController < ApplicationController
	def index
		redirect_to "/stats"
	end

  def login
    session[:user_id] = nil
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user && (user.role == "admin" || user.role == "stats")
        session[:user_id] = user.id
        session[:role] = user.role
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || "/stats")
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

end
