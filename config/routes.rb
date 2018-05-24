Rails.application.routes.draw do
  
  root 'ventas#index'
  get 'pages/ingresos', to:'pages#ingresos'
  get 'pages/estadisticas', to: 'pages#estadisticas'
  get 'pages/calculadora', to: 'pages#calculadora'
  post 'pages/ingresos', to:'pages#buscar'
  get 'clientes/busqueda', to: 'clientes#buscar_clientes'
  post 'clientes/busqueda', to:'clientes#buscar_clientes'
  
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :ventas, :clientes, :productos, :egresos
  
end
