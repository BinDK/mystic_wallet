class CreateAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :account_type
      t.decimal :balance
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
