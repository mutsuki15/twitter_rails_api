class Api::V1::TweetsController < ApplicationController
  def index
    tweets = Tweet.convert_hash_data(Tweet.not_comment.related_preload.limit_offset(offset).created_sort)
    tweets_empty = Tweet.after_next_empty?(offset)

    render json: { tweets:, next: tweets_empty[:next_empty], after_next: tweets_empty[:after_next_empty] },
           status: :ok
  end

  def show
    tweet = Tweet.convert_hash_data([Tweet.find(params[:id])])

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
    comments = Tweet.convert_hash_data(tweet.comment_tweets)

    render json: { comments: },
           status: :ok
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content)
  end

  def offset
    params[:page].to_i * 10
  end
end