Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }

  unauthenticated do
    root :to => 'index#index'
  end

  authenticated do
    root :to => 'uploads#index'
  end

  resources :uploads

  post 'snapshot', to: 'uploads#snapshot'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
