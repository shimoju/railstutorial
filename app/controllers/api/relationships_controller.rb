class Api::RelationshipsController < Api::ApplicationController
  before_action :check_auth_token, only: [:create, :destroy]

  def create
  end

  def destroy
  end
end
