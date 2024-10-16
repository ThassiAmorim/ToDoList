Rails.application.routes.draw do
  resources :todos
  resources :tasks

  get 'dashboard', to: 'todos#dashboard'

  root 'todos#index'

end
