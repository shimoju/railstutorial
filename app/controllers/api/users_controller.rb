
class Api::UsersController < Api::ApplicationController
  before_action :check_auth_token, only: [:index, :show, :update, :destroy, :following, :followers, :microposts]
  before_action :correct_user, only: :update
  before_action :admin_user, only: :destroy

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

  def microposts
    @user = User.find(params[:user_id])

    render nothing: true, status: :forbidden and return unless @user.activated?

    @microposts = @user.microposts

    render 'microposts', status: :ok
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      user = User.find(params[:id])
      render nothing: true, status: :forbidden and return unless user == current_user
    end
end
