require 'test_helper'

class Api::ListsDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @list = lists(:friend)
    correct_user = users(:michael)
    correct_token = correct_user.generate_jwt
    @correct_headers = {"Authorization" => "Bearer #{correct_token}"}

    wrong_user = users(:lana)
    wrong_token = wrong_user.generate_jwt
    @wrong_headers = {"Authorization" => "Bearer #{wrong_token}"}
  end

  test "正しいユーザでリストの削除" do
    assert_difference "List.count", -1 do
      delete api_list_path(@list), {}, @correct_headers 
    end
    assert_response :ok
  end

  test "間違ったユーザでリストの削除" do
    assert_no_difference "List.count" do
      delete api_list_path(@list), {}, @wrong_headers
    end

    assert_response :forbidden
  end
end
