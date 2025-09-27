class AddIndexesForPerformance < ActiveRecord::Migration[7.2]
  def change
    # User indexes
    add_index :users, :created_at

    # Account indexes
    add_index :accounts, :account_type
    add_index :accounts, [ :user_id, :account_type ]

    # Transaction indexes
    add_index :transactions, :transaction_date
    add_index :transactions, [ :account_id, :transaction_date ]
    add_index :transactions, [ :category_id, :transaction_date ]

    # Category indexes
    add_index :categories, :category_type
    add_index :categories, [ :name, :category_type ], unique: true
  end
end
