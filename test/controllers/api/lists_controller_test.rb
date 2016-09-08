require 'test_helper'

class Api::ListsControllerTest < ActionController::TestCase
  def setup
    @user = users(:michael)
  end

  test "create list with invalid data" do
    assert_no_diffrence "List.count" do
      post :create, format: :json, user: {
        name: "",
        user_id: ""
      }
    end
    assert_response :unprocessable_entity
  end

  test "create list with valid data" do
    assert_diffrence "List.count", 1 do
      post :create, format: :json, user: {
        name: "friends",
        user_id: @user.id
      }
    end
    assert_response :created
  end

  test "delete list with invalid data" do
    assert_no_diffrence "List.count" do
      delete :destroy, format: :json, user: {
        name: "friends",
        user_id: @user.id
      }
    end
  end
end
