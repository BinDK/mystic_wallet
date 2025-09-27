# == Schema Information
#
# Table name: accounts
#
#  id           :bigint           not null, primary key
#  account_type :string           not null
#  balance      :decimal(, )      not null
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_accounts_on_account_type              (account_type)
#  index_accounts_on_user_id                   (user_id)
#  index_accounts_on_user_id_and_account_type  (user_id,account_type)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Account < ApplicationRecord
  ACCOUNT_TYPES = %w[checking savings credit_card investment loan].freeze

  belongs_to :user
  has_many :transactions

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :account_type, presence: true, inclusion: { in: ACCOUNT_TYPES }
  validates :balance, presence: true, numericality: {
    greater_than_or_equal_to: -1_000_000,
    less_than_or_equal_to: 1_000_000
  }
  validates :user_id, presence: true

  validate :realistic_balance_for_account_type

  private

  def realistic_balance_for_account_type
    case account_type
    when "credit_card"
      errors.add(:balance, "should be negative or zero for credit cards") if balance > 0
    when "loan"
      errors.add(:balance, "should be negative for loans") if balance > 0
    else
      # Checking, savings, investment can have positive or negative balances
    end
  end
end
