require 'test_helper'

class ListMemberTest < ActiveSupport::TestCase
  def setup
    @list_member = ListMember.new(user_id: 1, list_id: 2)
  end

  test "正しい入力値" do
    assert @list_member.valid?
  end

  test "user_idが指定されていない" do
    @list_member.user_id = nil
    assert_not @list_member.valid?
  end

  test "list_idが指定されていない" do
    @list_member.list_id = nil
    assert_not @list_member.valid?
  end

end
