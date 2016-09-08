class Api::ListsController < ApplicationController
  before_action :check_auth_token, only: [:show, :create, :destroy]
  before_action :correct_user, only: :destroy

  def show
    @list_members = List.find(params[:id]).list_member
  end

  def create
    @list = current_user.lists.build(list_params)
    if @list.save
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
    list = List.find(params[:id])
    list.destroy
    render nothing: true, status: :ok
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end

  def correct_user
    list = current_user.lists.find(params[:id])
    render nothing: true, status: :forbidden and return if list.nil?
  end
end
