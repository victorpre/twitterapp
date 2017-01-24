Rails.application.routes.draw do

  get 'tweets/search'

  devise_for :users,:controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  get 'home', to: 'home#index'
  get 'tweets', to: 'tweets#index'
  root 'home#index'
end
