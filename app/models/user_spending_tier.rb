class UserSpendingTier < ApplicationRecord
  self.table_name = "user_spending_tiers"
  self.primary_key = nil

  def readonly?
    true
  end

  scope :by_tier, ->(tier) { where(spending_tier: tier) }
  scope :high, -> { by_tier("high") }
  scope :medium, -> { by_tier("medium") }
  scope :low, -> { by_tier("low") }
end
