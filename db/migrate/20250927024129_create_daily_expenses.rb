class CreateDailyExpenses < ActiveRecord::Migration[7.2]
  def change
    create_view :daily_expenses, materialized: false
  end
end
