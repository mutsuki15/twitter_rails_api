module Api
  module V1
    class UsersController < ApplicationController
      def show
        user = User.find_by(name: params[:name])
        tweets = Tweet.convert_hash_data(user.tweets.related_preload.created_sort)

        render json: { user: user.hash_data[:user], tweets:, is_current_user: user == current_api_v1_user },
               status: :ok
      end

      def update
        user = current_api_v1_user

        if user.update(user_params)
          render json: { status: :updated },
                 status: :ok
        else
          render json: { errors: user.errors },
                 status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:header, :icon, :bio, :location, :website, :phone)
      end

    end
  end
end