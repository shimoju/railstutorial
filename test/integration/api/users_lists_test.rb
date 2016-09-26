require 'test_helper'

class Api::UsersListsTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    token = @user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}
  end

  test "リスト一覧を取得" do
    my_list_names = @user.lists.map{|list| list.name}
    get api_lists_path, {}, @headers
    assert_response :ok

    response_json[:lists].each do |list|
      assert my_list_names.include?(list[:name])
    end
  end

  test "リストのページング" do
    get api_lists_path, {page: 1}, @headers
    assert_response :ok
    assert_equal 30, response_json[:lists].count

    get api_lists_path, {page: 2}, @headers
    assert_response :ok
    assert_equal 1, response_json[:lists].count
  end
end
