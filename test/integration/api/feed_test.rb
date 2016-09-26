require 'test_helper'

class Api::FeedTest< ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    
    token = @user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}
  end

  test "feed取得(デフォルト)" do
    get api_feed_path, {}, @headers
    assert_response :success

    assert_not_nil response_json[:feed]
    assert_kind_of Array, response_json[:feed]

    # feed配列の中身に値漏れがないかチェック
    response_json[:feed].each do |micropost|
      %i(content user_id created_at updated_at picture).each do |element|
        assert_not_nil micropost[element]
      end
    end

    # パラメータ無しのため、30件取得する
    assert_equal 30, response_json[:feed].length
  end

  test "feed取得(最新35件)" do
    get api_feed_path, {request_microposts: {count: 35}}, @headers
    assert_response :success

    # 35件取得する
    assert_equal 35, response_json[:feed].length
  end

  test "feed取得(最新10件)" do
    get api_feed_path, {request_microposts: {count: 10}}, @headers
    assert_response :success

    # 10件取得する
    assert_equal 10, response_json[:feed].length
  end

  test "feed取得(idが)" do
    get api_feed_path, {request_microposts: {count: 35}}, @headers
    assert_response :success

    # 50件取得する
    assert_equal 35, response_json[:feed].length

    # 全micropostのidが100超であることを検証
    response_json[:feed].each do |micropost|
      assert_operator micropost[:id], :>, 1000000000
    end
  end
end

