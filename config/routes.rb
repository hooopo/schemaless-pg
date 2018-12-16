Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq" # monitoring console
  root "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
