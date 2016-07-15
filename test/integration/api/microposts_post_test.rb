require 'test_helper'

class Api::MicropostsPostTest < ActionDispatch::IntegrationTest
  def setup
    user = users(:michael)
    token = user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}

    @micropost = microposts(:orange)
  end

  test "マイクロポストの投稿(認証あり)" do
    content = "this is picture"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference "Micropost.count", 1 do
      post api_microposts_path, {micropost: {content: content, picture: picture}}, @headers
    end

    assert_response :created
    assert assigns(:micropost).picture?

    params = response_json
    assert_equal params[:micropost][:content], content
  end

  test "空のマイクロポストの投稿(認証あり)" do
    assert_no_difference "Micropost.count" do
      post api_microposts_path, {micropost: {content: ""}}, @headers
    end
    assert_response :unprocessable_entity
  end

  test "マイクロポストの削除(認証あり)" do
    assert_difference "Micropost.count", -1 do
      delete api_micropost_path(@micropost), {}, @headers
    end
    assert_response :ok
  end
end
