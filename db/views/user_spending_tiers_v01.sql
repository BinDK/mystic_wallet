SELECT
  users.id as user_id,
  users.first_name || ' ' || users.last_name as user_name,
  COUNT(DISTINCT transactions.id) as total_transactions,
  SUM(ABS(transactions.amount)) as total_spent,
  AVG(ABS(transactions.amount)) as avg_transaction_amount,
  MAX(transactions.transaction_date) as last_transaction_date,
  MIN(transactions.transaction_date) as first_transaction_date,
  CASE
    WHEN SUM(ABS(transactions.amount)) >= ntile_80.value THEN 'high'
    WHEN SUM(ABS(transactions.amount)) >= ntile_50.value THEN 'medium'
    ELSE 'low'
  END as spending_tier
FROM users
JOIN accounts ON users.id = accounts.user_id
JOIN transactions ON accounts.id = transactions.account_id
CROSS JOIN (
  SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY user_total) as value
  FROM (
    SELECT SUM(ABS(transactions.amount)) as user_total
    FROM transactions
    JOIN accounts ON transactions.account_id = accounts.id
    GROUP BY accounts.user_id
  ) t
) ntile_50
CROSS JOIN (
  SELECT
    PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY user_total) as value
  FROM (
    SELECT SUM(ABS(transactions.amount)) as user_total
    FROM transactions
    JOIN accounts ON transactions.account_id = accounts.id
    GROUP BY accounts.user_id
  ) t
) ntile_80
GROUP BY users.id, users.first_name, users.last_name, ntile_50.value, ntile_80.value
ORDER BY total_spent DESC
