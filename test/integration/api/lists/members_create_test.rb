require 'test_helper'

class Api::Lists::MembersCreateTest < ActionDispatch::IntegrationTest
  def setup
    user = users(:michael)
    token = user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}
    @other_user = users(:ogido)
    @list = lists(:friend)
  end

  test "リストにユーザ追加" do
    assert_difference "@list.members.count", 1 do
      post api_list_members_path(@list), {user_id: @other_user.id }, @headers
    end
    assert_response :created
  end
end
