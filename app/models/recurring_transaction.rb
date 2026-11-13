class RecurringTransaction < ApplicationRecord
  self.table_name = "recurring_transactions"
  self.primary_key = nil

  def readonly?
    true
  end

  scope :by_account, ->(id) { where(account_id: id) }
  scope :by_category, ->(id) { where(category_id: id) }
  scope :by_user, ->(id) { where(user_id: id) }
  scope :frequent, -> { where("occurrence_count >= ?", 6) }
end
