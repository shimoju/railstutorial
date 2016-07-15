require 'test_helper'

class Api::UsersDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:michael)
    admin_token = @admin_user.generate_jwt
    @admin_headers = {"Authorization" => "Bearer #{admin_token}"}

    @non_admin_user = users(:lana)
    non_admin_token = @non_admin_user.generate_jwt
    @non_admin_headers = {"Authorization" => non_admin_token}
  end

  test "存在するユーザの削除(admin)" do
    assert_difference "User.count", -1 do
      delete api_user_path(@non_admin_user), {}, @admin_headers
    end
    assert_response :success
  end

  test "存在するユーザの削除(non_admin)" do
    assert_no_difference "User.count" do
      delete api_user_path(@admin_user), {}, @non_admin_headers
    end
    assert_response :forbidden
  end

  test "存在しないユーザの削除" do
    assert_no_difference "User.count" do
      delete api_user_path(-1), {}, @admin_headers 
    end
    assert_response :not_found
  end
end
