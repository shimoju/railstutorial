require 'test_helper'

class Api::UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:michael)
    ActionMailer::Base.deliveries.clear
  end

  test "user一覧取得(認証なし)" do
    get :index, format: :json
    assert_response :unauthorized
  end

  test "user情報の取得(認証なし)" do
    get :show, format: :json, id: @user
    assert_response :unauthorized
  end

  test "ユーザのmicropost一覧取得(認証なし)" do
    get :microposts, format: :json, user_id: @user
    assert_response :unauthorized
  end

  test "ユーザのfeed取得(認証なし)" do
    get :feed, format: :json
    assert_response :unauthorized
  end

  test "ユーザのサインアップ(失敗)" do
    assert_no_difference "User.count" do
      post :create, format: :json, user: {
                            name: "",
                            email: "user@invalid",
                            password: "foo",
                            password_confirmation: "bar"
                          }
    end
    assert_response :unprocessable_entity
  end

  test "ユーザのサインアップ(成功)" do
    assert_difference "User.count", 1 do
      post :create, format: :json, user: {
                            name: "Example User",
                            email: "user@example.com",
                            password: "password",
                            password_confirmation: "password"
                          }
    end
    assert_response :created
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

  test "ユーザの削除(認証なし)" do
    assert_no_difference "User.count" do
      delete :destroy, format: :json, id: @user.id
    end
    assert_response :unauthorized
  end

  test "ユーザのアップデート(認証なし)" do
    patch :update, format: :json, id: @user.id,
                                  user: {
                                          name: "ogidow",
                                          email: "test@test.com",
                                          password: "",
                                          password_confirmation: ""
                                        }
    assert_response :unauthorized
  end

  test "ユーザが所持しているリスト一覧取得(認証なし)" do
    get :lists, format: :json
  end

  test "フォローリストの表示(認証なし)" do
    get :following, format: :json, user_id: @user
    assert_response :unauthorized
  end

  test "フォロワーリストの表示(認証なし)" do
    get :followers, format: :json, user_id: @user
    assert_response :unauthorized
  end

  test "自分の情報を取得(認証なし)" do
    get :me, format: :json
    assert_response :unauthorized
  end
end
