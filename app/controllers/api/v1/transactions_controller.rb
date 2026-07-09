module Api
  module V1
    class TransactionsController < BaseController
      def index
        transactions = Transaction.includes(:account, :category)
                                   .select(:id, :account_id, :category_id, :amount, :description, :transaction_date, :created_at)
                                   .order(transaction_date: :desc, created_at: :desc)

        transactions = transactions.where(account_id: params[:account_id]) if params[:account_id]
        transactions = transactions.where(category_id: params[:category_id]) if params[:category_id]

        if params[:start_date].present?
          transactions = transactions.where("transaction_date >= ?", params[:start_date])
        end
        if params[:end_date].present?
          transactions = transactions.where("transaction_date <= ?", params[:end_date])
        end

        transactions = transactions.page(params[:page]).per(params[:per_page] || 20)

        render json: transactions.map { |t|
          {
            id: t.id,
            amount: t.amount,
            description: t.description,
            transaction_date: t.transaction_date,
            account_name: t.account.name,
            category_name: t.category.name,
            category_type: t.category.category_type,
            created_at: t.created_at
          }
        }
      end

      def show
        transaction = Transaction.includes(:account, :category).find(params[:id])
        render json: {
          id: transaction.id,
          amount: transaction.amount,
          description: transaction.description,
          transaction_date: transaction.transaction_date,
          account_name: transaction.account.name,
          account_type: transaction.account.account_type,
          category_name: transaction.category.name,
          category_type: transaction.category.category_type,
          created_at: transaction.created_at,
          updated_at: transaction.updated_at
        }
      end
    end
  end
end
