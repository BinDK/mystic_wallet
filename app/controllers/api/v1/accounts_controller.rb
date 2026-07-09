module Api
  module V1
    class AccountsController < BaseController
      def index
        accounts = Account.select(:id, :user_id, :name, :account_type, :balance, :created_at)
        accounts = accounts.where(user_id: params[:user_id]) if params[:user_id]
        accounts = accounts.order(created_at: :desc)
                           .page(params[:page])
                           .per(params[:per_page] || 20)
        render json: accounts
      end

      def show
        account = Account.select(:id, :user_id, :name, :account_type, :balance, :created_at)
                         .find(params[:id])
        render json: account
      end
    end
  end
end
