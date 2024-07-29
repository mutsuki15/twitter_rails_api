module Api
  module V1
    module Auth
      class UsersController < ApplicationController
        before_action :authenticate_api_v1_user!

        def current
          render json: { status: true, current_user: current_api_v1_user.hash_data(current_api_v1_user)[:user] },
                 status: :ok
        end
      end
    end
  end
end
