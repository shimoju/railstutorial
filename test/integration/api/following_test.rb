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

  test "フォローする人を指定しなければエラーを返すこと" do
    assert_no_difference "@user.following.count" do
      post api_relationships_path, {relationship: {followed_id: ""}}, @headers
    end
    assert_response :unprocessable_entity
  end

  test "アンフォローできること" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete api_relationship_path(relationship), {}, @headers
    end
    assert_response :ok
  end

  test "他のユーザーのフォローは操作できないこと" do
  end
end
