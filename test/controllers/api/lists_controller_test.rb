require 'test_helper'

class Api::ListsControllerTest < ActionController::TestCase
  def setup
    @user = users(:michael)
    @list = lists(:one)
  end

  test "create list with invalid data" do
    assert_no_difference "List.count" do
      post :create, format: :json, user: {
        name: "",
        user_id: ""
      }
    end
    assert_response :unprocessable_entity
  end

  test "delete list with invalid data" do
    assert_no_difference "List.count" do
      delete :destroy, format: :json, id: @list
    end
  end
end
