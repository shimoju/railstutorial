class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  DEFAULT_COUNT = 30 # micropost一覧はデフォルトでは30件とってくる

  def self.restrict count: DEFAULT_COUNT, since_id: nil, max_id: nil
    result = self # これにメソッドチェーンでクエリをつけていく

    unless since_id.nil?
      result = result.where(Micropost.arel_table[:id].gt since_id)
    end

    unless max_id.nil?
      result = result.where(Micropost.arel_table[:id].lteq max_id)
    end

    result.limit count
  end

  private

  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
