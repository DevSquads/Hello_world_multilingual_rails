Rails.application.routes.draw do
  resources :missions

  get '/missions/list/by_lang', to: 'missions#by_lang'

  root 'missions#new'
end
