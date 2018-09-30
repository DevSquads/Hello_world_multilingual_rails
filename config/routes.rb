Rails.application.routes.draw do
  scope "(:locale)", locale: /en|ar/ do
    get 'language/index'
  end

  post '/language', to: 'language#create'

  root 'language#index'
end
