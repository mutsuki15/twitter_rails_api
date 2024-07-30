class Notice < ApplicationRecord
  belongs_to :notice_user, class_name: 'User'
  belongs_to :noticed_user, class_name: 'User'
  belongs_to :tweet, optional: true
  belongs_to :notice_type
end
