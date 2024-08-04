class Notice < ApplicationRecord
  belongs_to :notice_user, class_name: 'User'
  belongs_to :noticed_user, class_name: 'User'
  belongs_to :tweet, optional: true
  belongs_to :notice_type

  def self.convert_hash_data(noticeds, current_user)
    noticeds.map { |notice| notice.hash_data(current_user) }
  end

  def hash_data(current_user)
    case notice_type.notice_name
    when 'いいね'
      { id:, type: 'いいね', tweet: JSON.parse(tweet.to_json), user: notice_user.hash_data(current_user)[:user] }
    when 'コメント'
      { id:, type: 'コメント', tweet: tweet.hash_data(current_user) }
    when 'フォロー'
      { id:, type: 'フォロー', user: notice_user.hash_data(current_user)[:user] }
    when 'リツイート'
      { id:, type: 'リツイート', tweet: JSON.parse(tweet.to_json), user: notice_user.hash_data(current_user)[:user] }
    end
  end

  scope :related_preload, -> { preload(tweet: [{ user: :follows }, :favorites, :retweets]) }
end
