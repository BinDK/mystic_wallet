SELECT
  accounts.id as account_id,
  accounts.name as account_name,
  categories.id as category_id,
  categories.name as category_name,
  categories.category_type,
  users.id as user_id,
  users.first_name || ' ' || users.last_name as user_name,
  ROUND(AVG(ABS(transactions.amount))::numeric, 2) as avg_amount,
  ROUND(STDDEV(ABS(transactions.amount))::numeric, 2) as amount_stddev,
  COUNT(*) as occurrence_count,
  MIN(transactions.transaction_date) as first_occurrence,
  MAX(transactions.transaction_date) as last_occurrence,
  EXTRACT(DAY FROM MIN(transactions.transaction_date)) as typical_day_of_month
FROM transactions
JOIN accounts ON transactions.account_id = accounts.id
JOIN categories ON transactions.category_id = categories.id
JOIN users ON accounts.user_id = users.id
GROUP BY accounts.id, accounts.name, categories.id, categories.name, categories.category_type, users.id, users.first_name, users.last_name
HAVING COUNT(*) >= 3
  AND STDDEV(ABS(transactions.amount)) < AVG(ABS(transactions.amount)) * 0.3
ORDER BY occurrence_count DESC, avg_amount DESC
