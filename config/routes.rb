Rails.application.routes.draw do
  resources :todos
  resources :tasks


  root 'todos#home'

end
