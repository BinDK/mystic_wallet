module Api
  module V1
    class UsersController < BaseController
      def index
        users = User.select(:id, :first_name, :last_name, :email, :phone, :gender, :created_at)
                    .order(created_at: :desc)
                    .page(params[:page])
                    .per(params[:per_page] || 20)
        render json: users
      end

      def show
        user = User.select(:id, :first_name, :last_name, :email, :phone, :gender, :created_at)
                   .find(params[:id])
        render json: user
      end
    end
  end
end
