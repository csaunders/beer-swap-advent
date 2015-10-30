Rails.application.routes.draw do
  resources :submissions, only: %i(show update edit) do
    collection do
      get "/all/:region" => "submissions#index", :as => :region
    end
  end

  root to: 'visitors#index'
  get '/your-submission' => 'submissions#your_submission', :as => :your_submission
  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
end
