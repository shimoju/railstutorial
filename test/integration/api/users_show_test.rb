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

    assert_not_nil response_json[:user]
    assert_equal @active_user[:name], response_json[:user][:name]
    # 他人のメールアドレスを見れないようにするため、showではメールアドレスを返さない
    assert_nil response_json[:user][:email]

    assert_equal @active_user.following.count, response_json[:user][:following_count]
    assert_equal @active_user.followers.count, response_json[:user][:followers_count]
    assert_equal @active_user.microposts.count, response_json[:user][:microposts_count]
  end

  test "non_activeなユーザ情報取得" do
    get api_user_path(@non_active_user), {}, @headers
    assert_response :forbidden
  end
end
