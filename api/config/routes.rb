Rails.application.routes.draw do
  namespace :v1 do
    resources :domains, only: [:index, :create, :show, :destroy] do
      get 'parse', on: :member
    end
  end
end
