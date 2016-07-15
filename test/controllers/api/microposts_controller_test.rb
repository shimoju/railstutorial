require 'test_helper'

class Api::MicropostsControllerTest < ActionController::TestCase

  def setup
    @micropost = microposts(:orange)
  end

  test "マイクロポストの投稿(認証なし)" do
    assert_no_difference "Micropost.count" do
      post :create, format: :json, micropost: { content: "ogidow"}
    end
    assert_response :unauthorized
  end

  test "マイクロポストの削除(認証なし)" do
    assert_no_difference "Micropost.count" do
      delete :destroy, format: :json, id: @micropost
    end
    assert_response :unauthorized
  end
end
