Rails.application.routes.draw do
  devise_for :users
  get "home", to: "static_pages#home"
  get "about", to: "static_pages#about"
  get "contact", to: "static_pages#contact"
  get "help", to: "static_pages#help"
  get "up" => "rails/health#show", as: :rails_health_check
  root "static_pages#home"
end
