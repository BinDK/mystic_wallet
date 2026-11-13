class CreateUserSpendingTiers < ActiveRecord::Migration[7.2]
  def up
    create_view :user_spending_tiers, materialized: true
    execute "REFRESH MATERIALIZED VIEW user_spending_tiers"
  end

  def down
    execute "DROP MATERIALIZED VIEW IF EXISTS user_spending_tiers"
  end
end
