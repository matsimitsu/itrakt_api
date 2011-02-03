Itrakt::Application.routes.draw do

  root :to => 'home#index'

  match 'shows/:tvdb_id/seasons/:season_number/episodes' => 'shows#season'
  match 'shows/:tvdb_id/seasons' => 'shows#seasons'

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
