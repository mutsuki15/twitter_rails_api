class Tweet < ApplicationRecord
  include Rails.application.routes.url_helpers

  validates :content, length: { maximum: 140 }

  belongs_to :user
  has_many_attached :images

  def self.convert_hash_data(tweets)
    tweets.map do |tweet|
      JSON.parse(tweet.to_json).merge(tweet.image_urls).merge(tweet.user.hash_data)
    end
  end

  def image_urls
    { images: images.attached? ? images.map { |image, _index| url_for(image) } : [] }
  end

  scope :related_preload, -> { with_attached_images.preload(:user) }

  scope :created_sort, -> { order(created_at: :desc) }

  scope :limit_offset, ->(offset) { limit(10).offset(offset) }
end