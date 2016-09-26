require 'test_helper'

class Api::UsersListsTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    token = @user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}
  end

  test "リスト一覧を取得" do
    list = lists(:friend)
    @user.lists.build(list).save

    get api_lists_path, {}, @headers
    assert_response :ok

    assert response_json[:lists].select{|my_list| my_list.name == list.name}
  end
end
