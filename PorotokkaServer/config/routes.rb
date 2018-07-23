Rails.application.routes.draw do
  resources :posts
  root 'posts#index'
  match "posts/data", :to => "posts#data", :as => "data", :via => "get"
  match "posts/db_action", :to => "posts#db_action", :as => "db_action", :via => "get"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
