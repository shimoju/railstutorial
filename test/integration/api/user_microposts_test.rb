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
      %i(content user_id created_at updated_at picture).each do |element|
        assert_not_nil micropost[element]
      end

      assert_equal @active_user.id, micropost[:user_id] # 本人のポスト
    end
  end

  test "non_activeなユーザのmicroposts情報取得" do
    get api_user_microposts_path(@non_active_user), {}, @headers
    assert_response :forbidden
  end
end
