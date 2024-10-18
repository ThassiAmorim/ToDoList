Rails.application.routes.draw do
  resources :todos
  resources :tasks, only: [:create, :update, :destroy]

  get 'dashboard', to: 'todos#dashboard'
  get 'planilha', to: 'todos#planilha'


  root 'todos#index'

end
