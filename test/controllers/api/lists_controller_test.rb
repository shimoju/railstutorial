require 'test_helper'

class Api::ListsControllerTest < ActionController::TestCase
  def setup
    @list = lists(:friend)
    @user = users(:ogido)
  end

  test "認証なしでリストを作成" do
    assert_no_difference "List.count" do
      post :create, format: :json, user: {
        name: "test",
        user_id: @user.id
      }
    end
    assert_response :unauthorized
  end

  test "認証なしでリストを削除" do
    assert_no_difference "List.count" do
      delete :destroy, format: :json, id: @list
    end
    assert_response :unauthorized
  end

  test "認証なしでfeedの取得" do
    get :feed, format: json, id: @list
    assert_response :unauthorized
  end

  test "認証なしでリストの更新" do
    patch :update, format: json, {list: {name: "ogidow"}, id: @list}
  end
end
