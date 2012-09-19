Carrie::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  scope "api" do
    resources :los do
      resources :introductions do
        collection {post :sort}
      end
      resources :exercises do
        resources :questions do
          resources :tips
          collection {post :sort}
        end
        collection { post :sort }
      end
    end
  end

  devise_for :users

  root to: "home#index"
  match '*path', to: 'home#index'
end
