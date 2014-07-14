Carrie::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  devise_for :users, :controllers => {:sessions => "sessions"}

  scope "api" do
    namespace :published do
      resources :los, only: :show
      match '/teams/:team_id/los/:id' => "los#show"
    end

    resources :comments,only: :index do
    end

    resources :answers do
      post 'retroaction', on: :member
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

  #get "answers_panel/index"
  #get "answers_panel/answers"

  namespace :newapi do
    resources :users, :only => [:index]
    resources :answers, :only => [:show] do
      member do
        get "connections"
      end
    end
    resources :connections, :only => [:create] do
      member do
        delete "reject_connection"
        put "accept_connection"
      end
    end
  end

  namespace :panel do
    #get "retroaction/:answer_id", :action => :retroaction
    #get "index"
    #get "comments"
    #get "explorer"
    resources :teams, only: [:show] do
      resources :los, only: [] do
        get 'overview', on: :member
      end
      resources :users, only: [:show] do
        resources :los, only: [:show] do
          resources :questions, only: [:show] do
            resources :answers, only: [:show] do
              post 'change_correctness', on: :member
            end
          end
        end
      end
    end
  end

  #namespace :explorer do
  #  get "index"
  #  get "load_users"
  #  post "info_answer"
  #  post "info_connection"
  #  put "search"
  #  put "fulltext_search"
  #end

  namespace :dashboard do
    get "home"

    get "timeline"
    put "timeline_search"

    get "search"
    put "fulltext_search"

    get "graph"
    put "graph_search"
    post "graph_answer_info"
    post "graph_connection_info"

    resources :teams, :only => [:new,:create,:destroy] do
      post :unenroll, on: :member
    end
    namespace :teams do
      get "available"
      post "enroll"
    end

    namespace :answers do
      get "show"
    end

    namespace :connections do
      get "show"
    end

    resources :messages do
      resources :replies, :only => [:create,:destroy]
    end

    namespace :tags do
      get "show"
      put "add_tag"
      post "create_tag"
      delete "remove_tag"
      put "accept_tag"
      put "reject_tag"
    end

    get "tags"
    put "tags_search"
  end

  root to: "dashboard#home"

  match '*path', to: 'home#index'
end
