Rails.application.routes.draw do
  resources :missions
  scope "(:locale)", locale: /en|ar/ do
    get 'language/index'
  end

  post '/language', to: 'language#create'

  get '/missions/list/by_lang', to: 'missions#by_lang'

  root 'missions#new'
end
