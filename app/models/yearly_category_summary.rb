class YearlyCategorySummary < ApplicationRecord
  self.table_name = "yearly_category_summaries"
  self.primary_key = nil

  def readonly?
    true
  end

  scope :by_year, ->(year) { where("EXTRACT(YEAR FROM year_date) = ?", year) }
  scope :by_category, ->(name) { where("LOWER(category_name) = LOWER(?)", name) }
  scope :by_type, ->(type) { where(category_type: type) }
end
