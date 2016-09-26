class Api::MicropostsController < Api::ApplicationController
  before_action :check_auth_token, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def show
    @micropost = Micropost.find_by(id: params[:id])
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      render status: :created
    else
      build_json = Jbuilder.encode do |json|
        json.message "Validation Failed"
        json.errors = @micropost.errors.messages 
      end
      render json: build_json, status: :unprocessable_entity
    end
  end

  def destroy
    micropost = Micropost.find_by(id: params[:id])
    micropost.destroy
    render nothing: true, status: :ok
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      micropost = current_user.microposts.find_by(id: params[:id])
      render nothing: true, status: :forbidden and return if micropost.nil?
    end
end
