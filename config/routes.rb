Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  get 'home/about'
  get 'games/index'
  get 'games/faune'
  get 'games/rabbit_jump'
  get 'games/starfall'
  get 'games/sork'

  root "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
