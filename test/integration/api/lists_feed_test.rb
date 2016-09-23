require 'test_helper'

class Api::ListsFeedTest < ActionDispatch::IntegrationTest
  def setup
    user = users(:michael)
    token = user.generate_jwt
    @headers = {"Authorization" => "Bearer #{token}"}

    @list = lists(:friend)
  end

  test "リストのfeed取得" do
    get feed_api_list_path(@list.id), {}, @headers

    assert_response :ok

    params = response_json
    assert_not_nil params[:feed]
    assert_kind_of Array, params[:feed]

    params[:feed].each do |micropost|
      %i(content user_id created_at updated_at picture).each do |element|
        assert_not_nil micropost[element]
      end
    end
  end
end
