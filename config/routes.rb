Rails.application.routes.draw do
  resources :products, only: %i[index show]
  resources :downloads, only: %i[index]
  get 'price_simulation', to: 'price_simulations#compute'
  resources :purchases, only: %i[index create]
end
