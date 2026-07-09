# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_07_08_075941) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "account_type", null: false
    t.decimal "balance", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_type"], name: "index_accounts_on_account_type"
    t.index ["user_id", "account_type"], name: "index_accounts_on_user_id_and_account_type"
    t.index ["user_id"], name: "index_accounts_on_user_id"
    t.check_constraint "account_type::text = ANY (ARRAY['checking'::character varying, 'savings'::character varying, 'credit_card'::character varying, 'investment'::character varying, 'loan'::character varying]::text[])", name: "valid_account_types"
    t.check_constraint "balance >= '-1000000'::integer::numeric AND balance <= 1000000::numeric", name: "balance_range"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "category_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_type"], name: "index_categories_on_category_type"
    t.index ["name", "category_type"], name: "index_categories_on_name_and_category_type", unique: true
    t.check_constraint "category_type::text = ANY (ARRAY['income'::character varying, 'expense'::character varying]::text[])", name: "valid_category_types"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal "amount", null: false
    t.text "description", null: false
    t.date "transaction_date", null: false
    t.bigint "account_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "transaction_date"], name: "index_transactions_on_account_id_and_transaction_date"
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["category_id", "transaction_date"], name: "index_transactions_on_category_id_and_transaction_date"
    t.index ["category_id"], name: "index_transactions_on_category_id"
    t.index ["transaction_date"], name: "index_transactions_on_transaction_date"
    t.check_constraint "amount >= '-100000'::integer::numeric AND amount <= 100000::numeric", name: "amount_range"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", default: "", null: false
    t.string "phone"
    t.string "gender"
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_users_on_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "categories"

  create_view "daily_expenses", sql_definition: <<-SQL
      SELECT transactions.transaction_date AS expense_date,
      categories.name AS category_name,
      categories.category_type,
      sum(abs(transactions.amount)) AS total_amount,
      count(*) AS transaction_count,
      accounts.name AS account_name,
      (((users.first_name)::text || ' '::text) || (users.last_name)::text) AS user_name
     FROM (((transactions
       JOIN categories ON ((transactions.category_id = categories.id)))
       JOIN accounts ON ((transactions.account_id = accounts.id)))
       JOIN users ON ((accounts.user_id = users.id)))
    WHERE ((categories.category_type)::text = 'expense'::text)
    GROUP BY transactions.transaction_date, categories.name, categories.category_type, accounts.name, users.first_name, users.last_name
    ORDER BY transactions.transaction_date DESC, (sum(abs(transactions.amount))) DESC;
  SQL
  create_view "monthly_category_summaries", materialized: true, sql_definition: <<-SQL
      SELECT date_trunc('month'::text, (transactions.transaction_date)::timestamp with time zone) AS month_date,
      categories.name AS category_name,
      categories.category_type,
      sum(abs(transactions.amount)) AS total_amount,
      count(*) AS transaction_count,
      sum(
          CASE
              WHEN (transactions.amount < (0)::numeric) THEN 1
              ELSE 0
          END) AS expense_count,
      sum(
          CASE
              WHEN (transactions.amount > (0)::numeric) THEN 1
              ELSE 0
          END) AS income_count,
      avg(abs(transactions.amount)) AS avg_transaction_amount,
      accounts.name AS account_name,
      (((users.first_name)::text || ' '::text) || (users.last_name)::text) AS user_name
     FROM (((transactions
       JOIN categories ON ((transactions.category_id = categories.id)))
       JOIN accounts ON ((transactions.account_id = accounts.id)))
       JOIN users ON ((accounts.user_id = users.id)))
    WHERE ((categories.category_type)::text = ANY ((ARRAY['income'::character varying, 'expense'::character varying])::text[]))
    GROUP BY (date_trunc('month'::text, (transactions.transaction_date)::timestamp with time zone)), categories.name, categories.category_type, accounts.name, users.first_name, users.last_name
    ORDER BY (date_trunc('month'::text, (transactions.transaction_date)::timestamp with time zone)) DESC, (sum(abs(transactions.amount))) DESC;
  SQL
end
