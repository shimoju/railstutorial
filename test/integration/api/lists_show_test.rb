require 'test_helper'

class Api::ListsShowTest < ActionDispatch::IntegrationTest
  def setup
    user = users(:michael)
    token = user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}
    @list = lists(:friend)
  end

  test "リストの情報取得" do
    get api_list_path(@list), {}, @headers
    params = response_json

    assert_equal params[:list][:name], @list.name
  end
end
