require 'test_helper'

class Api::UsersListsTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    token = @user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}
  end

  test "リスト一覧を取得" do
    my_list = @user.lists.first
    get api_lists_path, {}, @headers
    assert_response :ok

    assert response_json[:lists].select{|list| list[:name] == my_list.name}
  end
end
