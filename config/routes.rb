Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index show]
      resources :accounts, only: %i[index show]
      resources :categories, only: %i[index]
      resources :transactions, only: %i[index show]

      get "reports/monthly-spending", to: "reports#monthly_spending"
      get "reports/trend", to: "reports#trend"
      get "reports/top-spenders", to: "reports#top_spenders"
      get "reports/category-rank", to: "reports#category_rank"
    end
  end
end
