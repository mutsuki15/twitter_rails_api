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
    dependent: :destroy
  )
  has_many :followings, through: :follows, source: :follow_user

  has_many(
    :reverse_follows,
    class_name: 'Follow',
    foreign_key: :follow_user_id,
    dependent: :destroy
  )
  has_many :followers, through: :reverse_follows, source: :follower_user

  has_many(
    :noticeds,
    class_name: 'Notice',
    foreign_key: :noticed_user_id,
    dependent: :destroy,
    inverse_of: :noticed_user
  )
  has_many :noticed_users, through: :noticeds, source: :notice_user

  has_many(
    :notices,
    class_name: 'Notice',
    foreign_key: :notice_user_id,
    dependent: :destroy,
    inverse_of: :notice_user
  )
  has_many :notice_users, through: :notices, source: :noticed_user

  def icon_url
    { icon: icon.attached? ? url_for(icon) : nil }
  end

  def header_url
    { header: header.attached? ? url_for(header) : nil }
  end

  def hash_data(current_user)
    { user: JSON.parse(to_json).merge(icon_url).merge(header_url).merge(user_action(current_user)) }
  end

  def user_action(current_user)
    { action: {
      follow: follow_action(current_user)
    } }
  end

  def follow_action(current_user)
    followers.include?(current_user)
  end

  include DeviseTokenAuth::Concerns::User
end

class Follow < ApplicationRecord
  belongs_to :follow_user, class_name: 'User'
  belongs_to :follower_user, class_name: 'User'
end


module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_current_user, only: %i[show follow]
      
      def show
        user = User.find_by(name: params[:name])
        tweets = tweets_by_tab(user, params[:tab], @current_user)
        tweet_hash_data = Tweet.convert_hash_data(tweets, @current_user)
        
        user_data = user.hash_data(@current_user)[:user].merge(
          followings_count: user.followings.count,
          followers_count: user.followers.count
        )

        render json: { user: user_data, tweets: tweet_hash_data, is_current_user: user == @current_user },
               status: :ok
      end

      def update
        user = current_api_v1_user

        if user.update(user_params)
          render json: { status: :updated }, status: :ok
        else
          render json: { errors: user.errors }, status: :unprocessable_entity
        end
      end

      def follow
        follow_user = User.find_by(name: params[:name])
        follows = current_api_v1_user.follows.build(follow_user_id: follow_user.id)
        if follows.save
          render json: { status: :follow },
                 status: :ok
        else
          render json: { messages: 'フォローに失敗しました' },
                 status: :bad_request
        end
      end

      def unfollow
        unfollow_user = User.find_by(name: params[:name])
        follows = current_api_v1_user.follows.find_by(follow_user_id: unfollow_user.id)
        if follows.destroy
          render json: { status: :unfollow },
                 status: :ok
        else
          render json: { messages: 'フォロー解除に失敗しました' },
                 status: :bad_request
        end
      end

      private

      def user_params
        params.require(:user).permit(:header, :icon, :bio, :location, :website, :phone)
      end

      def set_current_user
        @current_user = current_api_v1_user
      end

      def tweets_by_tab(user, tab, current_user)
        case tab
        when 'tweets'
          user.tweets.not_comment_tweets
        when 'comments'
          user.tweets.comment_tweets
        when 'favorites'
          Tweet.joins(:favorites).where(favorites: { user_id: user.id })
        end
      end
    end
  end
end
