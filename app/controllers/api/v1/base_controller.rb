module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate

      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_error

      private

      def authenticate
        key = request.headers["X-Api-Key"] || params[:api_key]
        unless valid_api_key?(key)
          render json: { error: "unauthorized" }, status: :unauthorized
        end
      end

      def valid_api_key?(key)
        ActiveSupport::SecurityUtils.secure_compare(
          key.to_s,
          Rails.application.credentials.api_key.to_s
        )
      rescue ActiveSupport::MessageVerifier::InvalidSignature
        false
      end

      def not_found
        render json: { error: "not found" }, status: :not_found
      end

      def unprocessable_entity_error(exception)
        render json: { error: exception.record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
