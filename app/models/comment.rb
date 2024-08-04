class Comment < ApplicationRecord
  attribute :notice_type_id, default: -> {
    notice_type = NoticeType.find_or_create_by!(notice_name: 'コメント')
    notice_type.id
  }
  
  before_create :comment_notice

  belongs_to :parent_tweet, class_name: 'Tweet'
  belongs_to :comment_tweet, class_name: 'Tweet'
  belongs_to :notice_type

  def comment_notice
    noticed_user_id = Tweet.find(parent_tweet_id).user.id
    notice_user_id = Tweet.find(comment_tweet_id).user.id
    return if noticed_user_id == notice_user_id

    Notice.create!(
      noticed_user_id: noticed_user_id,
      notice_user_id: notice_user_id,
      tweet_id: Tweet.find(comment_tweet_id).id,
      notice_type_id: notice_type_id
    )
  end
end
