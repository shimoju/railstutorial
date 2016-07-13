require 'test_helper'

class Api::SessionsControllerTest < ActionController::TestCase
  test "jwtトークンの取得" do
    user = users(:michael)
    post :create, format: :json, user: {email: user.email, password: 'password'}
    params = api_params

    assert_response :success
    assert_not_nil params[:token]
  end

  test "正しくないパラメータでjwtトークンを取得" do
    post :create, format: :json, user: {email: "foo", password: ''}
    assert_response :unprocessable_entity
  end

  test "non_activeなユーザのjwtトークンを取得" do
    non_active_user = users(:ogido)

    post :create, format: :json, user: {email: non_active_user.email, password: 'pasword'} 
    assert_response :unprocessable_entity
  end

end
