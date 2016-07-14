class Api::SessionsController < ApplicationController
  protect_from_forgery :except => [:create]
  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user && @user.authenticate(params[:user][:password])
      if @user.activated?
        render status: :ok
      else
        build_json = Jbuilder.encode do |json|
          json.message "Account Not Activated"
        end
        render json: build_json, status: :unprocessable_entity
      end
    else
      build_json = Jbuilder.encode do |json|
        json.message "Invalid email/password combination"
      end
      render json: build_json, status: :unprocessable_entity
    end
  end
end
