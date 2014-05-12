class SessionsController < ApplicationController
	layout 'application'

	def new
	end

	def create
	  user = set_user
	  if user && user.authenticate(session_params[:password_digest])
	    session[:user_id] = user.id
	    session[:user_username] = user.username
	    redirect_to new_user_path, notice: "Logged in!"
	  else
	    flash.now.alert = "Usuário ou senha incorretos"
	    render "new"
	  end
	end

	def destroy
	  session[:user_id] = nil
	  session[:user_username] = nil
	  redirect_to login_path, notice: "Logged out!"
	end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      User.find_by_username(session_params[:username])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def session_params
      params.require(:session).permit(:username, :password_digest)
    end
end
