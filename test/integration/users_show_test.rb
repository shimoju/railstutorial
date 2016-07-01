require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @active_user = users(:archer)
    @non_active_user = users(:malory)
  end

  test"show as active user" do
    log_in_as(@user)
    get user_path(@active_user)
    assert_template "users/show"
    assert_match @active_user.name, response.body
  end
  
  test "show as non active_user" do
    log_in_as(@user)
    get user_path(@non_active_user)
    assert_redirected_to root_url
  end
end
