Rails.application.routes.draw do
  devise_for :users, controllers: {
  	confirmations: 'users/confirmations',
  	omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations' }

  resources :users, only: %i[index show edit update destroy] do
  	member do
  		patch :ban
      patch :resend_confirmation_instructions
      patch :resend_invitation
  	end
  end

  resources :posts do
    put 'publish' => 'posts#publish', on: :member, as: :publish
    put 'unpublish' => 'posts#unpublish', on: :member, as: :unpublish
  end

  root "static_pages#landing_page"
  get "privacy_policy", to: "static_pages#privacy_policy"
end
