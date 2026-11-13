class CreateYearlyCategorySummaries < ActiveRecord::Migration[7.2]
  def up
    create_view :yearly_category_summaries, materialized: true
    execute "REFRESH MATERIALIZED VIEW yearly_category_summaries"
  end

  def down
    execute "DROP MATERIALIZED VIEW IF EXISTS yearly_category_summaries"
  end
end
