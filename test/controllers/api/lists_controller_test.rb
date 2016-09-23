require 'test_helper'

class Api::ListsControllerTest < ActionController::TestCase
  def setup
    @list = lists(:friend)
  end

  test "create list with invalid data" do
    assert_no_difference "List.count" do
      post :create, format: :json, user: {
        name: "",
        user_id: ""
      }
    end
    assert_response :unauthorized
  end

  test "delete list with invalid data" do
    assert_no_difference "List.count" do
      delete :destroy, format: :json, id: @list
    end
  end
end
