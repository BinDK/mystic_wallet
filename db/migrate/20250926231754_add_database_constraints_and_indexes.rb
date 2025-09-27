class AddDatabaseConstraintsAndIndexes < ActiveRecord::Migration[7.2]
  def change
    # balance limit is one mil, reasonable for personal finance
    add_check_constraint :accounts, "balance >= -1000000 AND balance <= 1000000", name: "balance_range"

    # transaction amounts: Reasonable personal finance range, so 100K is alright
    add_check_constraint :transactions, "amount >= -100000 AND amount <= 100000", name: "amount_range"

    # goot match Account::ACCOUNT_TYPES constant
    add_check_constraint :accounts, "account_type IN ('checking', 'savings', 'credit_card', 'investment', 'loan')", name: "valid_account_types"

    # goot match Category::CATEGORY_TYPES constant
    add_check_constraint :categories, "category_type IN ('income', 'expense')", name: "valid_category_types"

    # NOT NULL constraints for required fields
    change_column_null :users, :email, false
    change_column_null :users, :first_name, false
    change_column_null :users, :last_name, false
    change_column_null :accounts, :name, false
    change_column_null :accounts, :account_type, false
    change_column_null :accounts, :balance, false, 0
    change_column_null :transactions, :amount, false
    change_column_null :transactions, :description, false
    change_column_null :transactions, :transaction_date, false
    change_column_null :categories, :name, false
    change_column_null :categories, :category_type, false
  end
end
