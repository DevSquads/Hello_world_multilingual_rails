Rails.application.routes.draw do
  resources :missions
  scope "(:locale)", locale: /en|ar/ do
    get 'language/index'
  end

  post '/language', to: 'language#create'

  root 'missions#new'
end
