require 'test_helper'

class Api::UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:michael)
    ActionMailer::Base.deliveries.clear
  end

  test "user一覧の取得(認証)" do
    get :index, format: :json
    params = JSON.parse(response.body, symbolize_names: true)

    first_page_users = User.where(activated: true).paginate(page: 1)
    users_names = params[:users].map{|user| user[:name]}

    first_page_users.each do |user|
      assert users_names.include?(user[:name])
    end
  end

  test "user情報の取得" do
    get :show, format: :json, id: @user
    assert_response :success

    params = JSON.parse(response.body, symbolize_names: true) 
    assert_not_nil params[:user]
    assert_equal @user[:name], params[:user][:name]
    assert_equal @user[:email], params[:user][:email]
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
end
