Itrakt::Application.routes.draw do

  root :to => 'home#index'

  resources :shows do
    match '/:tvdb_id/season/:season_number/episodes' => 'shows#season'
  end

  resources :users do
    collection do
      get :watched
      get :calendar
      get :library
    end
  end
end
