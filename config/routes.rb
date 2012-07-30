Carrie::Application.routes.draw do
  devise_for :users

  root to: "home#index"
  match '*path', to: 'home#index'
end
