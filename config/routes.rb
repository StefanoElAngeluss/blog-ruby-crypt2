Rails.application.routes.draw do
  devise_for :users, controllers: {
  	confirmations: 'users/confirmations',
  	omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users, only: %i[index show edit update destroy] do
  	member do
  		patch :ban
      patch :resend_confirmation_instructions
      patch :resend_invitation
  	end
  end

  root "static_pages#landing_page"
  get "privacy_policy", to: "static_pages#privacy_policy"
end
