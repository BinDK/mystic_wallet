class Transaction::TransactionTypeResolver
  def self.determine_type(account)
    case account.account_type
    when "checking" then random_type(0.8)  # 80% expense, 20% income
    when "savings" then random_type(0.3)   # 30% expense, 70% income
    when "credit_card" then "expense"      # Always expense (spending)
    when "investment" then random_type(0.2) # 20% expense, 80% income
    when "loan" then random_type(0.4)       # 40% expense, 60% income
    else
      random_type(0.5)
    end
  end

  private

  def self.random_type(true_ratio)
    Faker::Boolean.boolean(true_ratio:) ? "expense" : "income"
  end
end
