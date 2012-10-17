Carrie::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  scope "api" do
    namespace :published do
      resources :los, only: :show
      match '/teams/:team_id/los/:id' => "los#show"
    end

    resources :answers

    resources :teams do
      get 'created', on: :collection
      get 'enrolled', on: :collection
      post 'enroll', on: :member
      get 'page/:page', :action => :index, :on => :collection
    end

    resources :los do
      resources :introductions do
        collection {post :sort}
      end
      resources :exercises do
        delete 'delete_last_answers', :on => :member
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
