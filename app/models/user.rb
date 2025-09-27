# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  first_name      :string           default(""), not null
#  gender          :string
#  last_name       :string           default(""), not null
#  password_digest :string           default(""), not null
#  phone           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_created_at  (created_at)
#  index_users_on_email       (email) UNIQUE
#
class User < ApplicationRecord
  has_secure_password

  has_many :accounts

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :phone, presence: true
  validates :gender, inclusion: { in: %w[male female other], allow_nil: true }

  def self.mocking_password
    Rails.application.credentials.mocking.user.password
  end
end
