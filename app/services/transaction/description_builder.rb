class Transaction::DescriptionBuilder
  def self.generate_description(category)
    case category.name.downcase
    when "salary" then "Monthly salary payment"
    when "rent" then "Monthly rent payment"
    when "food" then [ "Lunch at restaurant", "Dinner out", "Takeout order", "Meal delivery" ].sample
    when "coffee" then [ "Morning coffee", "Afternoon coffee break", "Coffee shop visit" ].sample
    when "gas" then "Gas station fill-up"
    when "groceries" then "Weekly grocery shopping"
    when "entertainment" then [ "Movie tickets", "Concert tickets", "Streaming subscription", "Gaming expense" ].sample
    when "utilities" then "Monthly utility bill"
    when "insurance" then "Insurance premium payment"
    when "medical" then [ "Doctor visit", "Prescription medication", "Dental checkup", "Medical test" ].sample
    when "shopping" then [ "Online purchase", "Retail shopping", "Clothing purchase" ].sample
    when "transportation" then [ "Bus fare", "Taxi ride", "Uber ride", "Parking fee" ].sample
    when "investment return" then "Investment dividend payment"
    when "freelance" then "Freelance project payment"
    when "bonus" then "Performance bonus"
    else
      Faker::Commerce.product_name + " purchase"
    end
  end
end
