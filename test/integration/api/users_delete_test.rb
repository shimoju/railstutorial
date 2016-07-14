require 'test_helper'

class Api::UsersDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    token = @user.generate_jwt

    @headers = {"Authorization" => token}
  end

  test "存在するユーザの削除" do
    assert_difference "User.count", -1 do
      delete api_user_path(@user), {}, @headers
    end
    assert_response :success
  end

  test "存在しないユーザの削除" do
    assert_no_difference "User.count" do
      delete api_user_path(-1), {}, @headers 
    end
    assert_response :not_found
  end
end
