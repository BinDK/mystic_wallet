##
# This service is for mocking purpose, at the time this service created
# income and expense just do simple thing increase and decrease
# Check TO-DO below
class Transaction::BalanceManager
  def self.update_balance(account, amount, transaction_type)
    return handle_expense(account, amount) if transaction_type == "expense"

    handle_income(account, amount)
  end

  private

  def self.handle_expense(account, amount)
    # TODO: Personal wallet logic - simple balance updates
    # All account types use same logic: expenses decrease balance
    # No complex banking rules yet(overdraft fees, limits, etc.)
    update_query(account, account.balance - amount)
  end

  def self.handle_income(account, amount)
    update_query(account, account.balance + amount)
  end

  def self.update_query(account, new_balance)
    account.update!(balance: new_balance)
  end
end
