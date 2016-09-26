require 'test_helper'

class Api::Lists::MembersIndexTest < ActionDispatch::IntegrationTest
  def setup
    user = users(:michael)
    token = user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}
    @list = lists(:friend)
  end

  test "リストに追加されているメンバー一覧を取得" do
    get api_list_members_path(@list), {}, @headers

    assert_response :ok

    response_json[:members].each do |user|
      %i(id name email).each do |element|
        assert_not_nil micropost[element]
      end
    end
  end
end
