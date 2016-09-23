require 'test_helper'

class Api::FollowingTest < ActionDispatch::IntegrationTest
  def setup
    user = users(:michael)
    token = user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}
  end

  test "フォローできること" do
  end

  test "アンフォローできること" do
  end

  test "他のユーザーのフォローは操作できないこと" do
  end
end
