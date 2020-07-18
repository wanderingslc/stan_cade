Rails.application.routes.draw do
  # root 'main#index', as: 'main_index' 
  get 'main/index'
  get 'main/bunny_jump'
  get 'main/dungeon'
  get 'main/about'
  root 'main#index', as: 'home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
