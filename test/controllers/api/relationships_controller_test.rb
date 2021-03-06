require 'test_helper'

class Api::RelationshipsControllerTest < ActionController::TestCase
  test "Relationshipの作成には認証が必要" do
    assert_no_difference 'Relationship.count' do
      post :create, format: :json, relationship: { followed_id: users(:archer).id}
    end
    assert_response :unauthorized
  end

  test "Relationshipの削除には認証が必要" do
    assert_no_difference 'Relationship.count' do
      delete :destroy, format: :json, id: relationships(:one)
    end
    assert_response :unauthorized
  end

  test "Relationshipの削除には認証が必要(userId)" do
    assert_no_difference 'Relationship.count' do
      delete :destroy_by_userid, format: :json, relationship: { followed_id: users(:archer).id}
    end
    assert_response :unauthorized
  end
end
