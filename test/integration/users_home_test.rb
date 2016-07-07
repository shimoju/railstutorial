require 'test_helper'

class UsersHomeTest < ActionDispatch::IntegrationTest
  def setup 
    @user = users(:michael)
  end

  test "stat display" do
    log_in_as(@user)
    get root_path

    #統計値のチェック
    assert_match @user.following.count.to_s, response.body
    assert_match @user.followers.count.to_s, response.body

    assert_select "a[href=?]", following_user_path(@user)
    assert_select "a[href=?]", followers_user_path(@user)

  end
end
