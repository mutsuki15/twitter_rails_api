module Api
  module V1
    class NotificationsController < ApplicationController
      before_action :set_current_user, only: %i[index]

      def index
        notices = Notice.convert_hash_data(@current_user.noticeds, @current_user)
        render json: { notices: }, status: :ok
      end

      private

      def set_current_user
        @current_user = current_api_v1_user
      end
    end
  end
end
