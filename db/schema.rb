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

ActiveRecord::Schema[7.2].define(version: 2026_07_09_090401) do
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

  create_view "account_balance_histories", sql_definition: <<-SQL
      SELECT accounts.id AS account_id,
      accounts.name AS account_name,
      accounts.account_type,
      users.id AS user_id,
      (((users.first_name)::text || ' '::text) || (users.last_name)::text) AS user_name,
      transactions.transaction_date,
      transactions.amount,
      transactions.description,
      categories.name AS category_name,
      sum(transactions.amount) OVER (PARTITION BY accounts.id ORDER BY transactions.transaction_date, transactions.id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_amount
     FROM (((transactions
       JOIN accounts ON ((transactions.account_id = accounts.id)))
       JOIN users ON ((accounts.user_id = users.id)))
       JOIN categories ON ((transactions.category_id = categories.id)))
    ORDER BY accounts.id, transactions.transaction_date, transactions.id;
  SQL
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
  create_view "recurring_transactions", materialized: true, sql_definition: <<-SQL
      SELECT accounts.id AS account_id,
      accounts.name AS account_name,
      categories.id AS category_id,
      categories.name AS category_name,
      categories.category_type,
      users.id AS user_id,
      (((users.first_name)::text || ' '::text) || (users.last_name)::text) AS user_name,
      round(avg(abs(transactions.amount)), 2) AS avg_amount,
      round(stddev(abs(transactions.amount)), 2) AS amount_stddev,
      count(*) AS occurrence_count,
      min(transactions.transaction_date) AS first_occurrence,
      max(transactions.transaction_date) AS last_occurrence,
      EXTRACT(day FROM min(transactions.transaction_date)) AS typical_day_of_month
     FROM (((transactions
       JOIN accounts ON ((transactions.account_id = accounts.id)))
       JOIN categories ON ((transactions.category_id = categories.id)))
       JOIN users ON ((accounts.user_id = users.id)))
    GROUP BY accounts.id, accounts.name, categories.id, categories.name, categories.category_type, users.id, users.first_name, users.last_name
   HAVING ((count(*) >= 3) AND (stddev(abs(transactions.amount)) < (avg(abs(transactions.amount)) * 0.3)))
    ORDER BY (count(*)) DESC, (round(avg(abs(transactions.amount)), 2)) DESC;
  SQL
  create_view "user_spending_tiers", materialized: true, sql_definition: <<-SQL
      SELECT users.id AS user_id,
      (((users.first_name)::text || ' '::text) || (users.last_name)::text) AS user_name,
      count(DISTINCT transactions.id) AS total_transactions,
      sum(abs(transactions.amount)) AS total_spent,
      avg(abs(transactions.amount)) AS avg_transaction_amount,
      max(transactions.transaction_date) AS last_transaction_date,
      min(transactions.transaction_date) AS first_transaction_date,
          CASE
              WHEN ((sum(abs(transactions.amount)))::double precision >= ntile_80.value) THEN 'high'::text
              WHEN ((sum(abs(transactions.amount)))::double precision >= ntile_50.value) THEN 'medium'::text
              ELSE 'low'::text
          END AS spending_tier
     FROM ((((users
       JOIN accounts ON ((users.id = accounts.user_id)))
       JOIN transactions ON ((accounts.id = transactions.account_id)))
       CROSS JOIN ( SELECT percentile_cont((0.5)::double precision) WITHIN GROUP (ORDER BY ((t.user_total)::double precision)) AS value
             FROM ( SELECT sum(abs(transactions_1.amount)) AS user_total
                     FROM (transactions transactions_1
                       JOIN accounts accounts_1 ON ((transactions_1.account_id = accounts_1.id)))
                    GROUP BY accounts_1.user_id) t) ntile_50)
       CROSS JOIN ( SELECT percentile_cont((0.8)::double precision) WITHIN GROUP (ORDER BY ((t.user_total)::double precision)) AS value
             FROM ( SELECT sum(abs(transactions_1.amount)) AS user_total
                     FROM (transactions transactions_1
                       JOIN accounts accounts_1 ON ((transactions_1.account_id = accounts_1.id)))
                    GROUP BY accounts_1.user_id) t) ntile_80)
    GROUP BY users.id, users.first_name, users.last_name, ntile_50.value, ntile_80.value
    ORDER BY (sum(abs(transactions.amount))) DESC;
  SQL
  create_view "yearly_category_summaries", materialized: true, sql_definition: <<-SQL
      SELECT date_trunc('year'::text, (transactions.transaction_date)::timestamp with time zone) AS year_date,
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
    GROUP BY (date_trunc('year'::text, (transactions.transaction_date)::timestamp with time zone)), categories.name, categories.category_type, accounts.name, users.first_name, users.last_name
    ORDER BY (date_trunc('year'::text, (transactions.transaction_date)::timestamp with time zone)) DESC, (sum(abs(transactions.amount))) DESC;
  SQL
end
