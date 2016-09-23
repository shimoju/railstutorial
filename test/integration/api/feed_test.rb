require 'test_helper'

class Api::FeedTest< ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @active_user = users(:archer)
    @non_active_user = users(:ogido)
    
    token = @user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}
  end

  test "feed取得" do
    get api_feed_path, {}, @headers
    assert_response :success

    params = response_json
    assert_not_nil params[:feed]
    assert_kind_of Array, params[:feed]

    # feed配列の中身に値漏れがないかチェック
    params[:feed].each do |micropost|
      %i(content user_id created_at updated_at picture).each do |element|
        assert_not_nil micropost[element]
      end
    end
  end
end

