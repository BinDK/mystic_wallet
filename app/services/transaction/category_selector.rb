class Transaction::CategorySelector
  # categories: preloaded once per bulk run (avoids one query per transaction)
  def self.select_category(transaction_type, categories)
    category = categories.select { _1.category_type == transaction_type }.sample
    return category if category.present?

    Rails.logger.warn "No #{transaction_type} categories found, using any category"
    categories.sample
  end
end
