class Api::MicropostsController < Api::ApplicationController
  before_action :check_auth_token, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  def create

  end

  def destroy

  end

  private
    def microposts_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      micropost = current_user.microposts.find_by(id: params[:id])
      render nothing: true, status: :forbidden and return if microposts.nil?
    end
end
