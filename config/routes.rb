Itrakt::Application.routes.draw do

  root :to => 'home#index'

  match 'shows/:tvdb_id/seasons/:season_number/episodes' => 'shows#season'
  match 'shows/:tvdb_id/seasons' => 'shows#seasons'
  match 'shows/:tvdb_id/seasons_with_episodes' => 'shows#seasons_with_episodes'

  resources :updates

  resources :shows do
    get :trending, :on => :collection
  end

  resources :users do
    collection do
      get :watched
      get :calendar
      get :library
    end
  end
end
