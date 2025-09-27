class TransactionGeneratorJob < ApplicationJob
  queue_as :default

  COUNT = ENV.fetch("TRANSACTIONS_CREATE_COUNT", 50)

  def perform(*args)
    return unless ENV["TRANSACTION_CREATABLE"] == "true"

    Transaction::DataGenerator.create_bulk_transactions(COUNT)
  end
end
