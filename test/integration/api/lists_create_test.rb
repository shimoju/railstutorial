require 'test_helper'

class Api::ListCreateTest < ActionDispatch::IntegrationTest
  def setup
    user = users(:michael)
    token = user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}
  end

  test "正しい入力値でのリストの作成" do
    list_name = "lover"
    assert_difference "List.count", 1 do
      post api_lists_path, {list: {name: list_name}}, @headers
    end

    assert_response :created
    params = response_json

    assert_equal params[:list][:name], list_name
  end
end
