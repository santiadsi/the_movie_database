Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'movies/index'
  get 'movies/find_by_api', as: :find_by_api
  get 'movies/find_api_name', as: :find_api_name
  post 'create_movie/:movie_id', to: 'movies#create_movie', as: 'create_movie'
  root to: 'movies#index'
  resources :movies, only: [:new, :create]
end
