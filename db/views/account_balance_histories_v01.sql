SELECT
  accounts.id as account_id,
  accounts.name as account_name,
  accounts.account_type,
  users.id as user_id,
  users.first_name || ' ' || users.last_name as user_name,
  transactions.transaction_date,
  transactions.amount,
  transactions.description,
  categories.name as category_name,
  SUM(transactions.amount) OVER (
    PARTITION BY accounts.id
    ORDER BY transactions.transaction_date, transactions.id
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) as cumulative_amount
FROM transactions
JOIN accounts ON transactions.account_id = accounts.id
JOIN users ON accounts.user_id = users.id
JOIN categories ON transactions.category_id = categories.id
ORDER BY accounts.id, transactions.transaction_date, transactions.id
