Rails.application.routes.draw do
  resources :missions

  get 'missions/list_by_language', to: 'missions#list_by_language'

  root 'missions#new'
end
