Rails.application.routes.draw do
  resources :artists
  resources :about_us
  root to: 'application#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
