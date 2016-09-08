class List < ActiveRecord::Base
  belongs_to :user
  has_many :list_members, dependent: :destroy
end
