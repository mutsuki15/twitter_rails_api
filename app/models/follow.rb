class Follow < ApplicationRecord
  belongs_to :follow_user, class_name: 'User'
  belongs_to :follower_user, class_name: 'User'
end
