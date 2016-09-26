class List < ActiveRecord::Base
  belongs_to :user
  has_many :list_members, dependent: :destroy
  has_many :members, through: :list_members, source: :user
  
  validates :name, presence: true
  validates :user_id, presence: true

  def feed
    following_ids = "SELECT user_id FROM list_members WHERE list_id = :list_id"
    Micropost.where("user_id IN (#{following_ids})", list_id: id)
  end
end
