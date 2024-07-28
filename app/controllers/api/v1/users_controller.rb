module Api
  module V1
    class UsersController < ApplicationController
      def show
        user = User.find_by(name: params[:name])
        tweets = tweets_by_tab(user, params[:tab])
        tweet_hash_data = Tweet.convert_hash_data(tweets)
        
        render json: { user: user.hash_data[:user], tweets: tweet_hash_data, is_current_user: user == current_api_v1_user },
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

      private

      def user_params
        params.require(:user).permit(:header, :icon, :bio, :location, :website, :phone)
      end

      def tweets_by_tab(user, tab)
        case tab
        when 'tweets'
          user.tweets.not_comment_tweets
        when 'comments'
          user.tweets.comment_tweets
        else
          user.tweets
        end
      end
    end
  end
end
