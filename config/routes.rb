Rails.application.routes.draw do
  resources :messages
  resources :contacts, only: [:new, :create, :index]
  resources :requests
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :pages
  resources :flags
  resources :reviews do
   member do
    get "like", to: "reviews#upvote"
    get "dislike", to: "reviews#downvote"
   end
  end
  
  resources :offers do
   member do
    get "like", to: "offers#upvote"
    get "dislike", to: "offers#downvote"
   end
  end
  
  resources :offers do 
     resources :companies
  end
  
  resources :reviews do 
    resources :companies
    resources :flags
  end 
  
  resources :flags do
    resources :reviews
  end
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' } 
 
  
  resources :users, only: [:show]

  resources :companies do 
  	resources :reviews
  	 collection do 
  	 	get :search #creates new path for the search input
  	  get :autocomplete
     end
    resources :offers
     collection do 
      get :search #creates new path for the search input
     end
    resources :requests
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to:'companies#index'
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'tos', to: 'pages#tos'
  get 'privacy', to: 'pages#privacy'
  get 'profile', to: 'users#show'
  get 'testing', to: 'pages#testing'
  get 'faq', to: 'pages#faq'

  match 'users/:id' => 'users#show', via: :get

end
