# frozen_string_literal: true

class User < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  
  validates :name, presence: true, length: { maximum: 16 }, uniqueness: true
  validates :phone, presence: true
  validates :birthday, presence: true

  has_many :tweets, dependent: :destroy

  has_one_attached :icon
  has_one_attached :header

  has_many(
    :follows,
    class_name: 'Follow',
    foreign_key: :follower_user_id,
    dependent: :destroy,
    inverse_of: :follower_user
  )
  has_many :follow_users, through: :follows, source: :follow_user

  has_many(
    :followers,
    class_name: 'Follow',
    foreign_key: :follow_user_id,
    dependent: :destroy,
    inverse_of: :follow_user
  )
  has_many :follower_users, through: :followers, source: :follower_user

  def icon_url
    { icon: icon.attached? ? url_for(icon) : nil }
  end

  def header_url
    { header: header.attached? ? url_for(header) : nil }
  end

  def hash_data
    { user: JSON.parse(to_json).merge(icon_url).merge(header_url) }
  end

  include DeviseTokenAuth::Concerns::User
end