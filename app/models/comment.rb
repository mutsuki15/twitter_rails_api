class Comment < ApplicationRecord
  belongs_to :parent_tweet, class_name: 'Tweet'
  belongs_to :comment_tweet, class_name: 'Tweet'
  belongs_to :notice_type
end