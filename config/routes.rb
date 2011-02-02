Itrakt::Application.routes.draw do

  root :to => 'home#index'
  resources :users do
    collection do
      get :watched
      get :calendar
      get :library
    end
  end
end
