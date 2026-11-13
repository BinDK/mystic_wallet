class AccountBalanceHistory < ApplicationRecord
  self.table_name = "account_balance_histories"
  self.primary_key = nil

  def readonly?
    true
  end

  scope :by_account, ->(id) { where(account_id: id) }
  scope :by_user, ->(id) { where(user_id: id) }
  scope :by_date_range, ->(start_date, end_date) {
    where(transaction_date: start_date..end_date)
  }
end
