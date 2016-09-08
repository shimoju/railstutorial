class Api::Lists::ListMembersController < Api::ApplicationController
  before_action :check_auth_token, only: [:create, :destroy]

  def show
    @members = ListMember.find(params[:list_id])
  end

  def create
    @member = ListMember.new(list_member_params)
    if @member.save
      render status: :created
    else
      build_json = Jbuilder.encode do |json|
        json.message "Validation Failed"
        json.errors = @member.errors.messages
      end
      render json: build_json, status: :unprocessable_entity
    end
  end

  def destroy
    member = List.find(params[:list_id]).list_member.find(params[:id])
    member.destroy
    render nothing: true, status: :ok
  end

  private

  def list_member_params
    params.require(:member).permit(:list_id, :user_id)
  end
end
