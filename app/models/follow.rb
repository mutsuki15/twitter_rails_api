class Follow < ApplicationRecord
  attribute :notice_type_id, default: -> {
    notice_type = NoticeType.find_or_create_by!(notice_name: 'フォロー')
    notice_type.id
  }

  before_create :follow_notice

  belongs_to :follow_user, class_name: 'User'
  belongs_to :follower_user, class_name: 'User'
  belongs_to :notice_type

  def follow_notice
    noticed_user_id = follow_user_id
    return if noticed_user_id == follower_user_id

    Notice.create!(
      noticed_user_id: noticed_user_id,
      notice_user_id: follower_user_id,
      notice_type_id: notice_type_id
    )
  end
end
