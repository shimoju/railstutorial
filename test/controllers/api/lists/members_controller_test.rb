require 'test_helper'

class Api::Lists::MembersControllerTest < ActionController::TestCase
  def setup
    @list = lists(:friend)
    @user = users(:lana)
    @member = users(:archer)
  end

  test "認証なしでリストのユーザ一覧を取得" do
    get :index, format: :json, list_id: @list.id
    assert_response :unauthorized
  end

  test "認証なしでリストにユーザを追加" do
    post :create, format: :json, list_id: @list.id, user_id: @user.id
    assert_response :unauthorized
  end

  test "認証なしでリストからユーザを削除" do
    delete :destroy, format: :json, list_id: @list.id, id: @member.id
    assert_response :unauthorized
  end
end
