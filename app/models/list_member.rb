class ListMember < ActiveRecord::Base
  belongs_to :user
  belongs_to :list

  validates :list_id, presence: true
  validates :user_id, presence: true
end
