
include UsersHelper
class Api::UsersController < ApplicationController
  def index
    users = User.where(activated: true).paginate(page: params[:page])
    build_json = Jbuilder.encode do |json|
      json.users users
    end
    render json: build_json
  end

  def show
    user = User.find(params[:id])
    page = params[:page] || 1
    microposts = user.microposts.paginate(page: params[:page])
    build_json = Jbuilder.encode do |json|
      json.user do
        json.id user.id
        json.name user.name
        json.email user.email
        json.activated user.activated
        json.icon_url gravatar_for(user, url: true)
        json.microposts microposts
      end
    end

    render json: build_json
  end

  def create
    user = User.new(user_params)
    message = ""

    if user.save
      user.send_activation_email
      build_json = Jbuilder.encode do |json|
        json.message "Created"
      end
      render json: build_json, status: 201
    else
      build_json = Jbuilder.encode do |json|
        json.message "Validation Failed"
        json.errors user.errors.messages

      end
      render json: build_json, status: 500
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
