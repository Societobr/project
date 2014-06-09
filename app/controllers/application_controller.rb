class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

	def current_user
	  @current_user ||= User.find(session[:user_id]) if session[:user_id]
	end
	helper_method :current_user

	def authorize_parceiro
	  redirect_to login_url, alert: "Para acessar esta página é necessário autenticar-se." if current_user.nil?
	end

	def authorize_admin
	  if current_user.nil?
	  	redirect_to login_url, alert: "Para acessar esta página é necessário autenticar-se."
	  elsif @current_user.role.description == "PARCEIRO"
	  	redirect_to new_atividade_path, alert: "Você não tem permissão para acessar este recurso."
	  end
	end
end
