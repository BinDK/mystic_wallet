module Api
  module V1
    class CategoriesController < BaseController
      def index
        categories = Category.select(:id, :name, :category_type, :created_at)
                             .order(:name)
        render json: categories
      end
    end
  end
end
