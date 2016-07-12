
class Api::UsersController < ApplicationController
  before_action :approve, only: [:index, :edit, :update, :destroy, :following, :followers]

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
      render status: :created
    else
      build_json = Jbuilder.encode do |json|
        json.message "Validation Failed"
        json.errors @user.errors.messages
      end
      render json: build_json, status: :unprocessable_entity
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

    def approve
      token = request.authorization
      render status: :unauthorized and return if token.nil?
      render status: :unauthorized and return unless User.decode_jwt(token)
    end
end
