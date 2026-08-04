class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: [Settings.digit_500, Settings.digit_500]
  end

  validates :content, presence: true, length: {maximum: Settings.digit_140}

  validates :image,
            content_type: {
              in: Settings.image.micropost.content_types,
              message: I18n.t(
                "microposts.micropost.invalid_image_format"
              )
            },
            size: {
              less_than: Settings.digit_5.megabytes,
              message: I18n.t(
                "microposts.micropost.less_than_5_mb"
              )
            }

  scope :newest, ->{order(created_at: :desc)}
end
