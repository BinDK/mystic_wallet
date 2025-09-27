# == Schema Information
#
# Table name: monthly_category_summaries
#
#  account_name           :string
#  avg_transaction_amount :decimal(, )
#  category_name          :string
#  category_type          :string
#  expense_count          :bigint
#  income_count           :bigint
#  month_date             :timestamptz
#  total_amount           :decimal(, )
#  transaction_count      :bigint
#  user_name              :text
#
class MonthlyCategorySummary < ApplicationRecord
  self.table_name = "monthly_category_summaries"
  self.primary_key = nil

  attribute :month_date, :date
  attribute :category_name, :string
  attribute :category_type, :string
  attribute :total_amount, :decimal
  attribute :transaction_count, :integer
  attribute :expense_count, :integer
  attribute :income_count, :integer
  attribute :avg_transaction_amount, :decimal
  attribute :account_name, :string
  attribute :user_name, :string

  def readonly?
    true
  end

  scope :recent_months, -> { where("month_date >= ?", 6.months.ago) }
  scope :by_category, ->(category) { where(category_name: category) }
  scope :high_value, -> { where("total_amount > ?", 1000) }
  scope :income_categories, -> { where(category_type: "income") }
  scope :expense_categories, -> { where(category_type: "expense") }

  def self.refresh
    connection.execute("REFRESH MATERIALIZED VIEW monthly_category_summaries")
  end
end
