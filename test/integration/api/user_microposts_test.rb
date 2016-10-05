require 'test_helper'

class Api::UserMicropostsTest< ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @active_user = users(:archer)
    @non_active_user = users(:ogido)

    token = @user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}
  end

  test "activeなユーザ情報取得" do
    get api_user_microposts_path(@active_user), {}, @headers
    assert_response :success

    params = response_json
    assert_not_nil params[:microposts]
    assert_kind_of Array, params[:microposts]

    # microposts配列の中身に値漏れがないかチェック
    params[:microposts].each do |micropost|
      %i(content user_id created_at).each do |element|
        assert_not_nil micropost[element]
      end

      assert_equal @active_user.id, micropost[:user_id] # 本人のポスト
    end
  end

  test "non_activeなユーザのmicroposts情報取得" do
    get api_user_microposts_path(@non_active_user), {}, @headers
    assert_response :forbidden
  end

  test "userのmicrpost取得(最新10件)" do
    get api_user_microposts_path(@user), {request_microposts: {count: 10}}, @headers
    assert_response :success

    # 35件取得する
    assert_equal 10, response_json[:microposts].length
  end

  test "userのmicrpost取得(idが10より後のみ)" do
    get api_user_microposts_path(@user), {request_microposts: {since_id: 10}}, @headers
    assert_response :success

    # 全micropostのidが10超であることを検証
    response_json[:microposts].each do |micropost|
      assert_operator micropost[:id], :>, 10
    end
  end

  test "userのmicrpost取得(idが10以前のみ)" do
    get api_user_microposts_path(@user), {request_microposts: {max_id: 10}}, @headers
    assert_response :success

    # 全micropostのidが10以下であることを検証
    response_json[:microposts].each do |micropost|
      assert_operator micropost[:id], :<=, 10
    end
  end

  test "micropost取得(idが20以前かつ10より後のmicropostのみを5件取得)" do
    # since_idを指定
    get api_user_microposts_path(@user), {request_microposts: {count: 5, since_id: 10, max_id: 20}}, @headers
    assert_response :success

    # 全micropostのidが20以下10超であることを検証
    response_json[:microposts].each do |micropost|
      assert_operator micropost[:id], :<=, 20
      assert_operator micropost[:id], :>, 10
    end

    # 5件取得する
    assert_equal 5, response_json[:microposts].length
  end
end
