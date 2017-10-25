Rails.application.routes.draw do
  
  root 'pages#home'
  
  get 'pages/home', to:'pages#home'

  post 'pages/home', to:'pages#buscar'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :ventas, :clientes, :productos, :egresos
  
end
