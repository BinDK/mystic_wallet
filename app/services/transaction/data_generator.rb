class Transaction::DataGenerator
  def self.create_bulk_transactions(count = 100)
    transactions_created = 0
    count.to_i.times do |i|
      begin
        ActiveRecord::Base.transaction do
          transaction = create_single_transaction
          transactions_created += 1 if transaction
        end
      rescue StandardError => e
        Rails.logger.warn "Transaction creation failed (attempt #{i + 1}): #{e.message}"
      end
    end

    Rails.logger.info "Bulk transaction creation complete: #{transactions_created}/#{count} successful"
  end

  private

  def self.load_users
    return @loaded_users if @loaded_users.present?

    user_ids = Account.select(:user_id).limit(50).distinct.pluck(:user_id)
    @loaded_users ||= User.includes(:accounts).where(id: user_ids).order("RANDOM()").to_a
  end

  def self.create_single_transaction
    user = load_users.sample
    return unless user && user.accounts.any?

    account = user.accounts.sample
    transaction_type = Transaction::TransactionTypeResolver.determine_type(account)
    category = Transaction::CategorySelector.select_category(transaction_type)
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
end
