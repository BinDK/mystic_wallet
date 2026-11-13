class User::DataGenerator
  def self.create_user
    first_name = Faker::Name.first_name.downcase
    last_name = Faker::Name.last_name.downcase
    email = Faker::Internet.unique.email(name: "#{first_name}.#{last_name}")
    password = User.mocking_password
    phone = Faker::PhoneNumber.cell_phone
    gender = Faker::Gender.binary_type.downcase

    user = ActiveRecord::Base.transaction do
      User.create!(email:, first_name:, last_name:,
                   phone:, gender:, password:).tap do |u|
        User::AccountBuilder.create_accounts_for_user(u)
      end
    end

    Rails.logger.info "Created user: #{user.email} with #{user.accounts.count} accounts"
  end
end
