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

    assert_equal response_json[:list][:name], list_name
  end

  test "間違った入力値でリクエスト" do
    assert_no_difference "List.count" do
      post api_lists_path, {list: {name: ""}}, @headers
    end
    assert_response :unprocessable_entity
  end
end
