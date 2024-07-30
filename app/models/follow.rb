class Follow < ApplicationRecord
  attribute :notice_type_id, default: -> { NoticeType.find_by(notice_name: 'フォロー').id }
  before_create :follow_notice

  belongs_to :follow_user, class_name: 'User'
  belongs_to :follower_user, class_name: 'User'
  belongs_to :notice_type

  def follow_notice
    Notice.create!(
      noticed_user_id: follow_user_id,
      notice_user_id: follower_user_id,
      notice_type_id:
    )
  end
end
