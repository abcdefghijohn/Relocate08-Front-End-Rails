# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  get '/privacy', to: 'home#privacy'
  get '/auth/google_oauth2', as: :google_login
  get '/auth/google_oauth2/callback', to: 'sessions#create'
  get '/dashboard', to: 'dashboard#index', as: :dashboard
  get '/team', to: 'team#index', as: :team
  get '/logout', to: 'sessions#destroy'
  get '/utilities', to: 'utilities#index', as: :utilities_discover 
end
