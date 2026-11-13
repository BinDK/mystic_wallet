class CreateAccountBalanceHistories < ActiveRecord::Migration[7.2]
  def change
    create_view :account_balance_histories
  end
end
