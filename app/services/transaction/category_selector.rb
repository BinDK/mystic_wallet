class Transaction::CategorySelector
  def self.select_category(transaction_type)
    category = Category.where(category_type: transaction_type).sample
    return category if category.present?

    Rails.logger.warn "No #{transaction_type} categories found, using any category"
    Category.order("RANDOM()").first
  end
end
