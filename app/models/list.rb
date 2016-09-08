class List < ActiveRecord::Base
  belongs_to :user
  has_many :list_members, dependent: :destroy
  
  validates :name, presence: true
  validates :user_id, presence: true
end
