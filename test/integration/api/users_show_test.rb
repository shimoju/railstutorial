require 'test_helper'

class Api::UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @active_user = users(:archer)
    @non_active_user = users(:ogido)
    
    token = @user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}
  end

  test "activeなユーザ情報取得" do
    get api_user_path(@active_user), {}, @headers
    assert_response :success

    params = api_params
    assert_not_nil params[:user]
    assert_equal @active_user[:name], params[:user][:name]
    assert_equal @active_user[:email], params[:user][:email]
  end

  test "non_activeなユーザ情報取得" do
    get api_user_path(@non_active_user), {}, @headers
    assert_response :forbidden
  end
end
