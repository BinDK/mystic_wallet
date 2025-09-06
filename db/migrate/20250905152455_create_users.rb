class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest, null: false, default: ""
      t.string :phone
      t.string :gender
      t.string :first_name, default: ""
      t.string :last_name, default: ""

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
