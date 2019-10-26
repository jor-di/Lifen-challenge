Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :communications, only: [:index, :create]
    namespace :v2 do
      resources :practitioners, only: [] do
        resources :communications, only: [:create], module: :practitioners
      end
      resources :communications, only: [:index]
    end
  end
end
