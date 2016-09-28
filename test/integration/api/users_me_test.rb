require 'test_helper'

class Api::UsersMeTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    token = @user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}
  end

  test "自分の情報を取得" do
    get me_api_users_path, {}, @headers
    assert_response :ok

    assert_equal @user[:name], response_json[:user][:name]
    assert_equal @user[:email], response_json[:user][:email]

    assert_equal @user.following.count, response_json[:user][:following_count]
    assert_equal @user.followers.count, response_json[:user][:followers_count]
  end
end
