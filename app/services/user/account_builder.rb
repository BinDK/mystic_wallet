class User::AccountBuilder
  def self.create_accounts_for_user(user)
    Account.create!(
      user:,
      name: "Primary Checking",
      account_type: "checking",
      balance: Faker::Number.between(from: 500, to: 10_000)
    )

    if Faker::Boolean.boolean(true_ratio: 0.7)
      Account.create!(
        user:,
        name: "Emergency Savings",
        account_type: "savings",
        balance: Faker::Number.between(from: 1_000, to: 50_000)
      )
    end

    if Faker::Boolean.boolean(true_ratio: 0.6)
      Account.create!(
        user:,
        name: "Credit Card",
        account_type: "credit_card",
        balance: Faker::Number.between(from: -5_000, to: 0)
      )
    end

    if Faker::Boolean.boolean(true_ratio: 0.3)
      Account.create!(
        user:,
        name: "Investment Account",
        account_type: "investment",
        balance: Faker::Number.between(from: 5_000, to: 100_000)
      )
    end

    if Faker::Boolean.boolean(true_ratio: 0.2)
      Account.create!(
        user:,
        name: "Personal Loan",
        account_type: "loan",
        balance: Faker::Number.between(from: -10_000, to: -1_000)
      )
    end
  end
end
