class CreateMonthlyCategorySummaries < ActiveRecord::Migration[7.2]
  def change
    create_view :monthly_category_summaries, materialized: true
  end
end
