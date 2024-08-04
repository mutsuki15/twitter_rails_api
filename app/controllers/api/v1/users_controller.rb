module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_current_user, only: %i[show follow unfollow]

      def follow
        follow_user = User.find_by(name: params[:name])
        if follow_user
          follows = current_api_v1_user.follows.build(follow_user_id: follow_user.id)
          if follows.save
            render json: { status: :follow }, status: :ok
          else
            render json: { messages: follows.errors.full_messages }, status: :bad_request
          end
        else
          render json: { messages: 'ユーザーが見つかりません' }, status: :not_found
        end
      end

      def unfollow
        unfollow_user = User.find_by(name: params[:name])
        if unfollow_user
          follows = current_api_v1_user.follows.find_by(follow_user_id: unfollow_user.id)
          if follows&.destroy
            render json: { status: :unfollow }, status: :ok
          else
            render json: { messages: 'フォロー解除に失敗しました' }, status: :bad_request
          end
        else
          render json: { messages: 'ユーザーが見つかりません' }, status: :not_found
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
