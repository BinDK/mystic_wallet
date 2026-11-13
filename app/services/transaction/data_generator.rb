class Transaction::DataGenerator
  def self.create_bulk_transactions(count = 100)
    users = load_users
    categories = Category.all.to_a
    transactions_created = 0
    count.to_i.times do |i|
      begin
        ActiveRecord::Base.transaction do
          transaction = create_single_transaction(users, categories)
          transactions_created += 1 if transaction
        end
      rescue StandardError => e
        Rails.logger.warn "Transaction creation failed (attempt #{i + 1}): #{e.message}"
      end
    end

    Rails.logger.info "Bulk transaction creation complete: #{transactions_created}/#{count} successful"
  end

  # Loaded fresh on every run: a class-level cache would live for the whole
  # Sidekiq process, so new users would never be picked and balances would go stale.
  def self.load_users
    user_ids = Account.select(:user_id).limit(50).distinct.pluck(:user_id)
    User.includes(:accounts).where(id: user_ids).to_a
  end

  def self.create_single_transaction(users, categories)
    user = users.sample
    return unless user && user.accounts.any?

    account = user.accounts.sample
    transaction_type = Transaction::TransactionTypeResolver.determine_type(account)
    category = Transaction::CategorySelector.select_category(transaction_type, categories)
    amount = Transaction::AmountCalculator.generate_amount(category)
    description = Transaction::DescriptionBuilder.generate_description(category)
    transaction_date = Faker::Date.between(from: 30.days.ago, to: Date.today)

    transaction = Transaction.create!(
      account:, category:, amount:,
      description:, transaction_date:
    )

    Transaction::BalanceManager.update_balance(account, amount, transaction_type)
    transaction
  end

  private_class_method :load_users, :create_single_transaction
end
