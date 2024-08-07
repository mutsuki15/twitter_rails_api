class NoticeType < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :retweets, dependent: :destroy
end
