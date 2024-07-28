class Tweet < ApplicationRecord
  include Rails.application.routes.url_helpers

  validates :content, length: { maximum: 140 }

  belongs_to :user
  has_many_attached :images

  has_many(
    :comments,
    class_name: 'Comment',
    foreign_key: :parent_tweet_id,
    dependent: :destroy,
    inverse_of: :parent_tweet
  )

  has_many :comment_tweets, through: :comments, source: :comment_tweet

  has_one(
    :parent,
    class_name: 'Comment',
    foreign_key: :comment_tweet_id,
    dependent: :destroy,
    inverse_of: :comment_tweet
  )

  has_one :parent_tweet, through: :parent, source: :parent_tweet

  has_many :retweets, dependent: :destroy
  has_many :retweet_users, through: :retweets, source: :user

  def self.convert_hash_data(tweets, current_user)
    tweets.map { |tweet| tweet.hash_data(current_user) }
  end

  def hash_data(current_user, parent: true)
    hash_data = JSON.parse(to_json).merge(image_urls).merge(user.hash_data).merge(tweet_action(current_user))

    hash_data.merge!({ parent: parent_tweet.hash_data(current_user, parent: false) }) if parent_tweet.present? && parent

    hash_data
  end

  def image_urls
    { images: images.attached? ? images.map { |image, _index| url_for(image) } : [] }
  end

  def self.after_next_empty?(offset)
    {
      next_empty: !not_comment.limit_offset(offset + 10).empty?,
      after_next_empty: !not_comment.limit_offset(offset + 20).empty?
    }
  end

  def tweet_action(current_user)
    { action: { retweet: { retweeted: retweet_users.include?(current_user), count: retweets.count } } }
  end

  scope :not_comment_tweets, -> { related_preload.not_comment.created_sort }

  scope :comment_tweets, -> { related_preload.where_comment.created_sort }

  scope :related_preload, -> { with_attached_images.preload(:user).preload(parent_tweet: :user).preload(:retweets) }

  scope :created_sort, -> { order(created_at: :desc) }

  scope :limit_offset, ->(offset) { limit(10).offset(offset) }

  scope :not_comment, -> { where.not(parent: Comment.all) }

  scope :where_comment, -> { where(parent: Comment.all) }

  scope :not_comment_offset, ->(offset) { not_comment.limit_offset(offset) }
end
