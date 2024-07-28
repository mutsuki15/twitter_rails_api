class Api::V1::TweetsController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_tweet, only: %i[retweets favorites]

  def index
    tweets = Tweet.convert_hash_data(Tweet.not_comment.related_preload.limit_offset(offset).created_sort,
                                         current_api_v1_user)
    tweets_empty = Tweet.after_next_empty?(offset)

    render json: { tweets:, next: tweets_empty[:next_empty], after_next: tweets_empty[:after_next_empty] },
           status: :ok
  end

  def show
    tweet = Tweet.convert_hash_data([Tweet.find(params[:id])], current_api_v1_user)

    render json: { tweet: tweet.first },
           status: :ok
  end

  def create
    new_tweet = current_api_v1_user.tweets.build(tweet_params)
    if new_tweet.save
      render json: { status: :created, tweet: new_tweet },
             status: 200
    else
      render json: { status: :unprocessable_entity, errors: new_tweet.errors },
             status: 422
    end
  end

  def destroy
    tweet = current_api_v1_user.tweets.find(params[:id])
    return if tweet.blank?

    if tweet.destroy
      render json: { status: :deleted, deleted_id: params[:id] },
             status: :ok
    else
      render json: { status: :bad_request },
             status: :bad_request
    end
  end

  def comments
    tweet = Tweet.find(params[:id])
    comments = Tweet.convert_hash_data(tweet.comment_tweets, current_api_v1_user)

    render json: { comments: },
           status: :ok
  end

  def retweets
    current_user = current_api_v1_user
      if @tweet.retweet_users.include?(current_user)
        return unless @tweet.retweets.find_by(user_id: current_user.id).destroy

        render json: { id: @tweet.id, status: :deleted }, status: :ok
      else
        return unless @tweet.retweets.build(user_id: current_user.id).save

        render json: { id: @tweet.id, status: :created }, status: :ok
      end
  end

  def favorites
    current_user = current_api_v1_user
        if @tweet.favorite_users.include?(current_user)
          return unless @tweet.favorites.find_by(user_id: current_user.id).destroy

          render json: { id: @tweet.id, status: :deleted }, status: :ok
        else
          return unless @tweet.favorites.build(user_id: current_user.id).save

          render json: { id: @tweet.id, status: :created }, status: :ok
        end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content)
  end

  def offset
    params[:page].to_i * 10
  end

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end
end