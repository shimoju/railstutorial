require 'test_helper'

class UsersHomeTest < ActionDispatch::IntegrationTest
  def setup 
    @user = users(:michael)
  end

  test "stat display" do
    log_in_as(@user)
    get root_path

    #統計値のチェック
    assert_select "strong#following", @user.following.count.to_s
    assert_select "strong#followers", @user.followers.count.to_s

    assert_select "a[href=?]", following_user_path(@user)
    assert_select "a[href=?]", followers_user_path(@user)
  end
end
