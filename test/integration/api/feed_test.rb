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
      %i(content user_id created_at user).each do |element|
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

  test "feed取得(idが10より後のmicropostのみ)" do
    # since_idを指定
    get api_feed_path, {request_microposts: {since_id: 10}}, @headers
    assert_response :success

    # 全micropostのidが10超であることを検証
    response_json[:feed].each do |micropost|
      assert_operator micropost[:id], :>, 10
    end
  end

  test "feed取得(idが10以前のmicropostのみ)" do
    # since_idを指定
    get api_feed_path, {request_microposts: {max_id: 10}}, @headers
    assert_response :success

    # 全micropostのidが10以下であることを検証
    response_json[:feed].each do |micropost|
      assert_operator micropost[:id], :<=, 10
    end
  end

  test "feed取得(idが20以前かつ10より後のmicropostのみを5件取得)" do
    # since_idを指定
    get api_feed_path, {request_microposts: {count: 5, since_id: 10, max_id: 20}}, @headers
    assert_response :success

    # 全micropostのidが20以下10超であることを検証
    response_json[:feed].each do |micropost|
      assert_operator micropost[:id], :<=, 20
      assert_operator micropost[:id], :>, 10
    end

    # 5件取得する
    assert_equal 5, response_json[:feed].length
  end
end

