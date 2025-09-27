# == Schema Information
#
# Table name: transactions
#
#  id               :bigint           not null, primary key
#  amount           :decimal(, )      not null
#  description      :text             not null
#  transaction_date :date             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_id       :bigint           not null
#  category_id      :bigint           not null
#
# Indexes
#
#  index_transactions_on_account_id                        (account_id)
#  index_transactions_on_account_id_and_transaction_date   (account_id,transaction_date)
#  index_transactions_on_category_id                       (category_id)
#  index_transactions_on_category_id_and_transaction_date  (category_id,transaction_date)
#  index_transactions_on_transaction_date                  (transaction_date)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (category_id => categories.id)
#
class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :category

  validates :amount, presence: true, numericality: {
    greater_than_or_equal_to: -100_000,
    less_than_or_equal_to: 100_000
  }
  validates :description, presence: true, length: { minimum: 3, maximum: 255 }
  validates :transaction_date, :account_id, :category_id, presence: true

  validate :transaction_date_not_in_future

  private

  def transaction_date_not_in_future
    errors.add(:transaction_date, "cannot be in the future") if transaction_date.present? && transaction_date > Date.today
  end
end
