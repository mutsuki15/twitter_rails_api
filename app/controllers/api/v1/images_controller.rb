class Api::V1::ImagesController < ApplicationController
  def update
    tweet = current_api_v1_user.tweets.find(params[:id])
    if tweet.update(image_params)
      render json: { status: :updated },
             status: 200
    else
      render json: { status: :unprocessable_entity, errros: tweet.errors },
             status: 422
    end
  end

  private

  def image_params
    params.require(:tweet).permit(images: [])
  end
end