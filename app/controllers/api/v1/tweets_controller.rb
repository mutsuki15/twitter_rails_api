class Api::V1::TweetsController < ApplicationController
  def index
    tweets = Tweet.convert_hash_data(Tweet.related_preload.limit_offset(offset).created_sort)
    next_empty = Tweet.limit_offset(offset + 10).empty?
    after_next_empty = Tweet.limit_offset(offset + 20).empty?

    render json: { tweets:, next: !next_empty, after_next: !after_next_empty },
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

  private

  def tweet_params
    params.require(:tweet).permit(:content)
  end

  def offset
    params[:page].to_i * 10
  end
end