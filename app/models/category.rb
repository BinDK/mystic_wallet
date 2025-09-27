# == Schema Information
#
# Table name: categories
#
#  id            :bigint           not null, primary key
#  category_type :string           not null
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_categories_on_category_type           (category_type)
#  index_categories_on_name_and_category_type  (name,category_type) UNIQUE
#
class Category < ApplicationRecord
  CATEGORY_TYPES = %w[income expense].freeze

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 2, maximum: 50 }
  validates :category_type, presence: true, inclusion: { in: CATEGORY_TYPES }

  has_many :transactions

  before_save :titleize_name

  private

  def titleize_name
    self.name = name.titleize if name.present?
  end
end
