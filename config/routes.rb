Rails.application.routes.draw do
  scope "(:locale)", locale: /en|ar/ do
    get 'app/index'
  end

  post '/app', to: 'app#create'

  root 'app#index'
end
