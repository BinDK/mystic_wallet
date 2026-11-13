class CreateRecurringTransactions < ActiveRecord::Migration[7.2]
  def up
    create_view :recurring_transactions, materialized: true
    execute "REFRESH MATERIALIZED VIEW recurring_transactions"
  end

  def down
    execute "DROP MATERIALIZED VIEW IF EXISTS recurring_transactions"
  end
end
