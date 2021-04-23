Rails.application.routes.draw do
  devise_for :users, controllers: {
  	confirmations: 'confirmations' }
  resources :users, only: %i[index show destroy] do
  	member do
  		patch :ban
  	end
  end

  root "static_pages#landing_page"
  get "privacy_policy", to: "static_pages#privacy_policy"
end
