require 'test_helper'

class Api::MicropostsShowTest < ActionDispatch::IntegrationTest
  def setup
    user = users(:michael)
    token = user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}

    @micropost = microposts(:orange)
  end

  test "マイクロポストの閲覧" do
    get api_micropost_path(@micropost), {}, @headers
    assert_response :success

    response_micropost = response_json[:micropost]
    assert_not_nil response_micropost

    # 中身チェック
    assert_equal @micropost.id,        response_micropost[:id]
    assert_equal @micropost.content,   response_micropost[:content]
    assert_equal @micropost.user_id,   response_micropost[:user_id]
    assert_equal @micropost.picture.url, response_micropost[:picture]
    # 時間の形式がDBと出力jsonで違うので合わせる
    assert_equal @micropost.created_at.xmlschema(3), response_micropost[:created_at]
  end
end
