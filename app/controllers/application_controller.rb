class ApplicationController < ActionController::Base
  
  http_basic_authenticate_with name: "leo", password: "secreto"
  
  protect_from_forgery with: :exception
  
end
