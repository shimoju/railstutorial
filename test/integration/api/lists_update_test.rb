require 'test_helper'

class Api::ListsUpdateTest < ActionDispatch::IntegrationTest
  def setup
    @list = lists(:friend)
    correct_user = users(:michael)
    correct_token = correct_user.generate_jwt
    @correct_headers = {"Authorization" => "Bearer #{correct_token}"}

    wrong_user = users(:lana)
    wrong_token = wrong_user.generate_jwt
    @wrong_headers = {"Authorization" => "Bearer #{wrong_token}"}
  end

  test "自分のリスト名を変更" do

    list_name = "enginner"
    patch api_list_path(@list), {list: {name: list_name}}, @correct_headers
    
    assert_response :ok
    params = response_json
    @list.reload

    assert_equal @list.name, list_name
    assert_equal params[:list][:name], list_name
  end

  test "自分のリストを正しくないパラメータ変更" do
    patch api_list_path(@list), {list: {name: ""}}, @correct_headers
    
    assert_response :unprocessable_entity
  end

  test "他人のリスト名を変更" do
    list_name = "enginner"
    patch api_list_path(@list), {list: {name: list_name}}, @wrong_headers

    assert_response :forbidden
    @list.reload
    assert_not_equal @list.name, list_name
  end
end
