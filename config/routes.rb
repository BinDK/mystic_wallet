Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index show]
      resources :accounts, only: %i[index show]
      resources :categories, only: %i[index]
      resources :transactions, only: %i[index show]
    end
  end
end
