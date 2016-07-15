require 'test_helper'

class Api::UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    token = @user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}
  end

  test "正しくないパラメータで更新" do
    patch api_user_path(@user), { user: {
                                   name: "",
                                   email: "foo@invalid",
                                   password: "foo",
                                   password_confimation: "bar"
                                 }
                           }, @headers
    assert_response :unprocessable_entity
  end

  test "正しいパラメータで更新" do
    name = "ogidow"
    email = "test@test.com"
    patch api_user_path(@user), { user: {
                                   name: name,
                                   email: email,
                                   password: "",
                                   password_confirmation: ""
                                  }
                           }, @headers
    assert_response :success

    params = response_json

    assert_equal params[:user][:name], name
    assert_equal params[:user][:email], email
  end
end
