Carrie::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  scope "api" do
    namespace :published do
      resources :los, only: :show
      match '/teams/:team_id/los/:id' => "los#show"
    end

    resources :answers do
      get 'retroaction', on: :member
      get 'page/:page', :action => :index, :on => :collection
      resources :comments
    end

    match '/home/lo_example' => "home#lo_example"
    resources :retroaction_answers, only: :create
    resources :contacts, only: :create

    resources :teams do
      get 'created', on: :collection
      get 'enrolled', on: :collection
      get 'my_teams', on: :collection
      get 'teams_for_search', on: :collection
      get 'learners', on: :collection
      post 'enroll', on: :member
      get 'page/:page', :action => :index, :on => :collection
    end

    resources :los do
      get 'my_los', on: :collection
      get 'los_for_search', on: :collection
      get 'exercises', on: :collection
      resources :introductions do
        collection {post :sort}
      end
      resources :exercises do
        delete 'delete_last_answers', :on => :member
        resources :questions do
          resources :tips
          resources :test_cases
          collection {post :sort}
        end
        collection { post :sort }
      end
    end
  end

  devise_for :users
  
  get "answers_panel/index"
  
  root to: "home#index"

  match '*path', to: 'home#index'
end
