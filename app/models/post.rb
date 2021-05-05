# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  title        :string
#  views        :integer          default(0)
#  user_id      :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  image        :string
#  published    :boolean          default(FALSE)
#  published_at :datetime
#
class Post < ApplicationRecord
  belongs_to :user

  validates :title, length: { minimum: 5 }
  # validates :content, length: { minimum: 50 }

  mount_uploader :image, ImageUploader

  scope :post_recent, -> { order(published_at: :desc) }
  scope :published, -> { where(published: true) }

  def display_day_published
  	"Publier le #{published_at.strftime('%-b %-d, %-Y')}"
  end

  def publish
  	update(published: true, published_at: Time.now)
  end

  def unpublish
  	update(published: false, published_at: nil)
  end

end
