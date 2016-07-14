require 'test_helper'

class Api::UsersDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    token = @user.generate_jwt

    @headers = {"Authorization" => token}
  end

  test "ユーザの削除" do
    assert_difference "User.count", -1 do
      delete api_user_path(@user), {}, @headers
    end
    assert_response :success
  end
end
