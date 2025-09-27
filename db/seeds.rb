expense_categories = [
  { name: "food", category_type: "expense" },
  { name: "coffee", category_type: "expense" },
  { name: "rent", category_type: "expense" },
  { name: "gas", category_type: "expense" },
  { name: "groceries", category_type: "expense" },
  { name: "entertainment", category_type: "expense" },
  { name: "utilities", category_type: "expense" },
  { name: "insurance", category_type: "expense" },
  { name: "medical", category_type: "expense" },
  { name: "shopping", category_type: "expense" },
  { name: "transportation", category_type: "expense" }
]

income_categories = [
  { name: "salary", category_type: "income" },
  { name: "investment Return", category_type: "income" },
  { name: "freelance", category_type: "income" },
  { name: "bonus", category_type: "income" }
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
