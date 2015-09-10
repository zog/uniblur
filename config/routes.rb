Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }

  get '/result', to: 'static#s3_results', as: :s3_results

  resources :pictures

  namespace :admin do
    root to: 'home#index'

    resources :users
    resources :pictures

    resources :signed_urls, only: :index
  end
end
