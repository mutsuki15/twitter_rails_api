class Api::V1::TweetsController < ApplicationController
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
end