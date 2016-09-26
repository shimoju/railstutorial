require 'test_helper'

class Api::Lists::MembersDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @list = lists(:friend)
    correct_user = users(:michael)
    correct_token = correct_user.generate_jwt
    @correct_headers = {"Authorization" => "Bearer #{correct_token}"}

    @member = users(:ogido)

    @wrong_user = users(:lana)
    wrong_token = @wrong_user.generate_jwt
    @wrong_headers = {"Authorization" => "Bearer #{wrong_token}"}
  end

  test "リストからユーザを削除" do
    @list.list_members.build(user_id: @member.id).save
    assert_difference "@list.members.count", -1 do
      delete api_list_member_path(@list.id, @member.id), {}, @correct_headers
    end
    assert_response :ok
  end

  test "他人のリストに追加されているユーザを削除" do
    @list.list_members.build(user_id: @member.id).save
    assert_no_difference "@list.members.count" do
      delete api_list_member_path(@list.id, @member.id), {}, @wrong_headers
    end
    assert_response :forbidden
  end

  test "リストにいないユーザを削除" do
    assert_no_difference "@list.members.count" do
      delete api_list_member_path(@list.id, @wrong_user.id), {}, @correct_headers
    end
    assert_response :unprocessable_entity
  end

end
