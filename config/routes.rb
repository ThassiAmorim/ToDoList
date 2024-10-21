Rails.application.routes.draw do
  resources :todos
  resources :tasks, only: [:create, :update, :destroy]

  get 'dashboard', to: 'todos#dashboard'
  get 'planilha', to: 'todos#planilha'

  root 'todos#index'

  resources :todos do
    collection do
      post 'upload_image', to: 'todos#upload_image'
    end
  end


end
