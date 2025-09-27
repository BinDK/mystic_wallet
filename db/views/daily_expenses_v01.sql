SELECT
  DATE(transactions.transaction_date) as expense_date,
  categories.name as category_name,
  categories.category_type,
  SUM(ABS(transactions.amount)) as total_amount,
  COUNT(*) as transaction_count,
  accounts.name as account_name,
  users.first_name || ' ' || users.last_name as user_name
FROM transactions
JOIN categories ON transactions.category_id = categories.id
JOIN accounts ON transactions.account_id = accounts.id
JOIN users ON accounts.user_id = users.id
WHERE categories.category_type = 'expense'
GROUP BY DATE(transactions.transaction_date), categories.name, categories.category_type, accounts.name, users.first_name, users.last_name
ORDER BY expense_date DESC, total_amount DESC;