class Api::RelationshipsController < Api::ApplicationController
  before_action :check_auth_token

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    render status: :created
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    render nothing: true, status: :ok
  end
end
