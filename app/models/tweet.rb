class Tweet < ApplicationRecord
  include Rails.application.routes.url_helpers

  validates :content, length: { maximum: 140 }

  belongs_to :user
  has_many_attached :images
end