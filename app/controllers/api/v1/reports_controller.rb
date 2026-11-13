module Api
  module V1
    class ReportsController < BaseController
      def monthly_spending
        summaries = MonthlyCategorySummary
          .select(:month_date, :category_name, :category_type, :total_amount, :transaction_count, :expense_count, :income_count, :avg_transaction_amount)

        if params[:year].present?
          year = params[:year].to_i
          summaries = summaries.where("EXTRACT(YEAR FROM month_date) = ?", year)
        end

        if params[:category].present?
          summaries = summaries.where("LOWER(category_name) = LOWER(?)", params[:category])
        end

        if params[:type].present?
          summaries = summaries.where(category_type: params[:type])
        end

        summaries = summaries.order(month_date: :desc, total_amount: :desc)
                             .page(params[:page]).per(params[:per_page])

        render json: summaries
      end

      def trend
        # The view is per user/account; sum it to one point per month and type
        monthly = MonthlyCategorySummary
          .group(:month_date, :category_type)
          .select("month_date, category_type, SUM(total_amount) AS total_amount, SUM(transaction_count) AS transaction_count")
          .order(:month_date, :category_type)

        monthly = monthly.where(category_type: params[:type]) if params[:type].present?

        if params[:start_date].present?
          monthly = monthly.where("month_date >= ?", params[:start_date])
        end
        if params[:end_date].present?
          monthly = monthly.where("month_date <= ?", params[:end_date])
        end

        render json: monthly
      end

      def top_spenders
        tiers = UserSpendingTier
          .select(:user_id, :user_name, :total_transactions, :total_spent, :avg_transaction_amount, :spending_tier)
          .order(total_spent: :desc)

        tiers = tiers.by_tier(params[:tier]) if params[:tier].present?

        tiers = tiers.page(params[:page]).per(params[:per_page])

        render json: tiers
      end

      def category_rank
        # The view is per user/account; sum it so each category is ranked once per month
        monthly = MonthlyCategorySummary
          .group(:month_date, :category_name, :category_type)
          .select("month_date, category_name, category_type, SUM(total_amount) AS total_amount, SUM(transaction_count) AS transaction_count")
          .order(Arel.sql("month_date DESC, SUM(total_amount) DESC"))

        monthly = monthly.where(category_type: params[:type]) if params[:type].present?
        monthly = monthly.where("EXTRACT(YEAR FROM month_date) = ?", params[:year].to_i) if params[:year].present?

        grouped = monthly.group_by(&:month_date)
        result = grouped.map do |month, rows|
          ranked = rows.each_with_index.map { |r, i|
            {
              month: month,
              category_name: r.category_name,
              category_type: r.category_type,
              total_amount: r.total_amount.to_s,
              transaction_count: r.transaction_count,
              rank: i + 1
            }
          }
          { month: month, categories: ranked }
        end

        render json: result
      end
    end
  end
end
