require 'test_helper'

class Api::FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other = users(:archer)
    token = user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}
  end

  test "フォローできること" do
    assert_difference '@user.following.count', 1 do
      post api_relationships_path, {relationship: {followed_id: @other.id}}, @headers
    end
    assert_response :created

    params = response_json
    assert_equal params[:relationship][:followed_id], @other.id
  end

  test "アンフォローできること" do
  end

  test "他のユーザーのフォローは操作できないこと" do
  end
end
