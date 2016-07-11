
include UsersHelper
class Api::UsersController < ApplicationController
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.send_activation_email
      render status: 201
    else
      render status: 422
    end
  end

  def update
  end

  def destroy
  end

  def following
  end

  def followers
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
