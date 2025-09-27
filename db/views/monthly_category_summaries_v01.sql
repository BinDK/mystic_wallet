SELECT
  DATE_TRUNC('month', transactions.transaction_date) as month_date,
  categories.name as category_name,
  categories.category_type,
  SUM(ABS(transactions.amount)) as total_amount,
  COUNT(*) as transaction_count,
  SUM(CASE WHEN transactions.amount < 0 THEN 1 ELSE 0 END) as expense_count,
  SUM(CASE WHEN transactions.amount > 0 THEN 1 ELSE 0 END) as income_count,
  AVG(ABS(transactions.amount)) as avg_transaction_amount,
  accounts.name as account_name,
  users.first_name || ' ' || users.last_name as user_name
FROM transactions
JOIN categories ON transactions.category_id = categories.id
JOIN accounts ON transactions.account_id = accounts.id
JOIN users ON accounts.user_id = users.id
WHERE categories.category_type IN ('income', 'expense')
GROUP BY DATE_TRUNC('month', transactions.transaction_date), categories.name, categories.category_type, accounts.name, users.first_name, users.last_name
ORDER BY month_date DESC, total_amount DESC;