require 'test_helper'

class ListTest < ActiveSupport::TestCase
  def setup
    @list = List.new(user_id: 1, name: "example_list")
  end

  test "正しい入力値" do
    assert @list.valid?
  end

  test "user_idが指定されていない" do
    @list.user_id = nil
    assert_not @list.valid?
  end

  test "nameが空" do
    @list.name = ""
    assert_not @list.valid?
  end
end
