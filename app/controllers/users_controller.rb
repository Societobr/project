class UsersController < ApplicationController
	layout 'dashboard/dashboard'
	before_action :set_user, only: [:show, :edit, :update, :destroy]
	before_filter :authorize_admin

	def new
	  @user = User.new
	end

	def create
	  @user = User.new(user_params)
	  if @user.save
	    redirect_to user_path(@user), notice: "Parceiro criado com sucesso."
	  else
	    render "new"
	  end
	end

	def show
	end

	def destroy
		@user.destroy
		redirect_to users_path, notice: 'Registro excluído com sucesso.'
	end

	def update
	  if @user.update(user_params)
      	redirect_to @user, notice: 'Parceiro atualizado com sucesso.'
      else
        render "edit"
      end
	end

	def index
		@users = User.all
	end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password, :role_id)
    end
end
