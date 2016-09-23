class Api::RelationshipsController < Api::ApplicationController
  before_action :check_auth_token

  def create
    @user = User.find_by(id: relationship_params[:followed_id])
    render nothing: true, status: :unprocessable_entity and return if @user.nil?

    current_user.follow(@user)
    render nothing: true, status: :created
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    render nothing: true, status: :ok
  end

  private
    def relationship_params
      params.require(:relationship).permit(:followed_id)
    end
end
