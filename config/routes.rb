Itrakt::Application.routes.draw do

  root :to => 'home#index'

  match 'shows/:tvdb_id/season/:season_number/episodes' => 'shows#season'
  resources :shows

  resources :users do
    collection do
      get :watched
      get :calendar
      get :library
    end
  end
end
