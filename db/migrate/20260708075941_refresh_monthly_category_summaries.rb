class RefreshMonthlyCategorySummaries < ActiveRecord::Migration[7.2]
  def up
    execute "REFRESH MATERIALIZED VIEW monthly_category_summaries"
  end

  def down
    # Nothing to undo — refresh is idempotent
  end
end
