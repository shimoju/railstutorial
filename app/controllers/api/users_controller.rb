
class Api::UsersController < ApplicationController
  before_action :approve, only: [:index, :edit, :update, :destroy, :following, :followers]

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
      auth_header = request.authorization
      render nothing: true, status: :unauthorized and return if auth_header.nil?
      token = auth_header.split(" ").last
      decoded_token = User.decode_jwt(token)
      render nothing: true,  status: :unauthorized and return unless decoded_token
    end
end
