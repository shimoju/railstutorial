require 'test_helper'

class Api::ListsFeedTest < ActionDispatch::IntegrationTest
  def setup
    user = users(:lana)
    token = user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}

    @list = lists(:curry)
  end

  test "リストのfeed取得" do
    get feed_api_list_path(@list), {}, @headers

    assert_response :ok

    assert_not_nil response_json[:feed]
    assert_kind_of Array, response_json[:feed]

    response_json[:feed].each do |micropost|
      %i(content user_id created_at user).each do |element|
        assert_not_nil micropost[element]
      end
    end
    assert_equal 30, response_json[:feed].count
  end

  test "feed取得(最新35件)" do
    get feed_api_list_path(@list), {request_microposts: {count: 35}}, @headers
    assert_response :success

    # 35件取得する
    assert_equal 35, response_json[:feed].length
  end

  test "feed取得(最新10件)" do
    get feed_api_list_path(@list), {request_microposts: {count: 10}}, @headers
    assert_response :success

    # 10件取得する
    assert_equal 10, response_json[:feed].length
  end


  test "feed取得(idが10より後のmicropostのみ)" do
    # since_idを指定
    get feed_api_list_path(@list), {request_microposts: {since_id: 10}}, @headers
    assert_response :success

    # 全micropostのidが10超であることを検証
    response_json[:feed].each do |micropost|
      assert_operator micropost[:id], :>, 10
    end
  end

  test "feed取得(idが10以前のmicropostのみ)" do
    # since_idを指定
    get feed_api_list_path(@list), {request_microposts: {max_id: 10}}, @headers
    assert_response :success

    # 全micropostのidが10以下であることを検証
    response_json[:feed].each do |micropost|
      assert_operator micropost[:id], :<=, 10
    end
  end

  test "feed取得(idが20以前かつ10より後のmicropostのみを5件取得)" do
    # since_idを指定
    get feed_api_list_path(@list), {request_microposts: {count: 5, since_id: 10, max_id: 20}}, @headers
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
