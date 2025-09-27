# == Schema Information
#
# Table name: daily_expenses
#
#  account_name      :string
#  category_name     :string
#  category_type     :string
#  expense_date      :date
#  total_amount      :decimal(, )
#  transaction_count :bigint
#  user_name         :text
#
class DailyExpense < ApplicationRecord
  self.table_name = "daily_expenses"
  self.primary_key = nil

  attribute :expense_date, :date
  attribute :category_name, :string
  attribute :category_type, :string
  attribute :total_amount, :decimal
  attribute :transaction_count, :integer
  attribute :account_name, :string
  attribute :user_name, :string

  def readonly?
    true
  end

  scope :recent, -> { where("expense_date >= ?", 30.days.ago) }
  scope :by_category, ->(category) { where("LOWER(category_name) = LOWER(?)", category) }
  scope :high_spending, -> { where("total_amount > ?", 100) }
end
