class UserGeneratorJob < ApplicationJob
  queue_as :default

  def perform(*args)
    return unless ENV["USER_CREATABLE"] == "true"

    User::DataGenerator.create_user
  end
end
