class Retweet < ApplicationRecord
  attribute :notice_type_id, default: -> {
    notice_type = NoticeType.find_or_create_by!(notice_name: 'リツイート')
    notice_type.id
  }
  
  before_create :retweet_notice

  belongs_to :tweet
  belongs_to :user
  belongs_to :notice_type

  def retweet_notice
    noticed_user_id = Tweet.find(tweet_id).user.id
    return if noticed_user_id == user_id

    Notice.create!(
      noticed_user_id: noticed_user_id,
      notice_user_id: user_id,
      tweet_id: tweet_id,
      notice_type_id: notice_type_id
    )
  end
end
