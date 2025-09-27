class Transaction::AmountCalculator
  def self.generate_amount(category)
    case category.name.downcase
    when "salary" then amount_between(from: 3000, to: 8000)
    when "rent" then amount_between(from: 800, to: 2500)
    when "food" then amount_between(from: 10, to: 50)
    when "coffee" then amount_between(from: 3, to: 8)
    when "gas" then amount_between(from: 40, to: 80)
    when "groceries" then amount_between(from: 50, to: 200)
    when "entertainment" then amount_between(from: 20, to: 100)
    when "utilities" then amount_between(from: 100, to: 300)
    when "insurance" then amount_between(from: 150, to: 400)
    when "medical" then amount_between(from: 50, to: 500)
    when "shopping" then amount_between(from: 25, to: 150)
    when "transportation" then amount_between(from: 5, to: 50)
    when "investment return" then amount_between(from: 100, to: 2000)
    when "freelance" then amount_between(from: 200, to: 1000)
    when "bonus" then amount_between(from: 500, to: 3000)
    else
      amount_between
    end
  end

  private

  def self.amount_between(from: 10, to: 100)
    Faker::Number.between(from:, to:)
  end
end
