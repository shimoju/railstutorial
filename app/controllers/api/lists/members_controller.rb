class Api::Lists::MembersController < Api::ApplicationController
  before_action :check_auth_token
  before_action :correct_user, except: [:index]

  def index
    @members = List.find(params[:list_id]).members
  end

  def create
    list = List.find_by(id: params[:list_id])
    @user = User.find_by(id: params[:user_id])
    render json: "{}", status: :unprocessable_entity and return if list.nil? || @user.nil?
    member = list.list_members.build(user_id: @user.id)

    if member.save
      render status: :created
    else
      build_json = Jbuilder.encode do |json|
        json.message "Validation Failed"
        json.errors = member.errors.messages
      end
      render json: build_json, status: :unprocessable_entity
    end
  end

  def destroy
    list = List.find_by(id: params[:list_id])
    render json: "{}", status: :unprocessable_entity and return if list.nil?
    list_member = list.list_members.find_by(user_id: params[:id])
    render json: "{}", status: :unprocessable_entity and return if list_member.nil?

    list_member.destroy
    render json: "{}", status: :ok
  end
  
  private
  def correct_user
    list = List.find_by(id: params[:list_id])
    render json: "{}", status: :forbidden and return unless current_user.lists.include?(list)
  end

end
