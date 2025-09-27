expense_categories = [
  { name: "Food", category_type: "expense" },
  { name: "Coffee", category_type: "expense" },
  { name: "Rent", category_type: "expense" },
  { name: "Gas", category_type: "expense" },
  { name: "Groceries", category_type: "expense" },
  { name: "Entertainment", category_type: "expense" },
  { name: "Utilities", category_type: "expense" },
  { name: "Insurance", category_type: "expense" },
  { name: "Medical", category_type: "expense" },
  { name: "Shopping", category_type: "expense" },
  { name: "Transportation", category_type: "expense" }
]

income_categories = [
  { name: "Salary", category_type: "income" },
  { name: "Investment Return", category_type: "income" },
  { name: "Freelance", category_type: "income" },
  { name: "Bonus", category_type: "income" }
]

expense_categories.each do |category_attrs|
  Category.find_or_create_by!(name: category_attrs[:name]) do |category|
    category.category_type = category_attrs[:category_type]
  end
end

income_categories.each do |category_attrs|
  Category.find_or_create_by!(name: category_attrs[:name]) do |category|
    category.category_type = category_attrs[:category_type]
  end
end

3.times { User::DataGenerator.create_user }

puts "Created #{User.count} users, #{Account.count} accounts, and #{Category.count} categories"
