Rails.application.routes.draw do
  devise_for :users
  resources :pins

  root to: "pins#index"
end
