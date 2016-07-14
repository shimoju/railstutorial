
class Api::UsersController < ApplicationController
  before_action :approve, only: [:index, :show, :update, :destroy, :following, :followers]
  before_action :current_user, only: [:update]
  before_action :admin_user, only: [:destroy]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])

    render nothing: true, status: :forbidden unless @user.activated?
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
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      render status: :ok
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find_by(id: params[:id])
    render nothing: true, status: :not_found and return if user.nil? 

    user.destroy
    render nothing: true, status: :ok
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
      auth_header = request.authorization
      render nothing: true, status: :unauthorized and return if auth_header.nil?
      token = auth_header.split(" ").last
      decoded_token = User.decode_jwt(token)
       @decoded_user_info = decoded_token.first
      render nothing: true,  status: :unauthorized and return unless decoded_token
    end

    def current_user
      render nothing: true, status: :forbidden and return unless params[:id].to_i == @decoded_user_info["user_id"]
    end

    def admin_user
      user = User.find(@decoded_user_info["user_id"])
      render nothing: true, status: :forbidden and return unless user.admin?
    end
end
