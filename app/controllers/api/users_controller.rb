
class Api::UsersController < Api::ApplicationController
  before_action :check_auth_token, except: [:create]
  before_action :correct_user, only: :update
  before_action :admin_user, only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])

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
      # メールアドレスも返すようにする
      render 'me', status: :ok
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
    @user = User.find(params[:user_id])
    @users = @user.following.paginate(page: params[:page])
    render 'following', status: :ok
  end

  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers.paginate(page: params[:page])
    render 'followers', status: :ok
  end

  def microposts
    @user = User.find(params[:user_id])

    render nothing: true, status: :forbidden and return unless @user.activated?

    @microposts = @user.microposts.restrict(request_microposts_params.to_h.symbolize_keys)

    render 'microposts', status: :ok
  end

  def feed
    @user = current_user
    render nothing: true, status: :forbidden and return unless @user.activated?
    @feed = @user.feed.restrict(request_microposts_params.to_h.symbolize_keys)

    render 'feed', status: :ok
  end

  def lists
    @user = current_user
    render nothing: true, status: :forbidden and return unless @user.activated?
    @lists = @user.lists.paginate(page: params[:page])
    render status: :ok
  end

  def me
    @user = current_user
    render 'me', status: :ok
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def request_microposts_params
      params.fetch(:request_microposts, {}).permit(:since_id, :max_id, :count)
    end

    def correct_user
      user = User.find(params[:id])
      render nothing: true, status: :forbidden and return unless user == current_user
    end
end
