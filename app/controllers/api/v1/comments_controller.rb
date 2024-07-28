module Api
  module V1
    class CommentsController < ApplicationController
      def create
        comment = Comment.new(parent_tweet_id: params[:parent_tweet_id], comment_tweet_id: params[:comment_tweet_id])
        if comment.save
          render json: { comment: },
                 status: :ok
        else
          render json: { message: 'コメントの作成に失敗しました' },
                 status: :bad_request
        end
      end
    end
  end
end