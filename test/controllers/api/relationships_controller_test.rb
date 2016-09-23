require 'test_helper'

class Api::RelationshipsControllerTest < ActionController::TestCase
  test "Relationshipの作成には認証が必要" do
    assert_no_difference 'Relationship.count' do
      post :create, format: :json
    end
    assert_response :unauthorized
  end

  test "Relationshipの削除には認証が必要" do
    assert_no_difference 'Relationship.count' do
      delete :destroy, format: :json, id: relationships(:one)
    end
    assert_response :unauthorized
  end
end
