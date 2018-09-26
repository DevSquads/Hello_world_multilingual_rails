Rails.application.routes.draw do
  scope "(:locale)", locale: /en|ar/ do
    get 'app/index'
  end

  post 'app/', to: 'app#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'app#index'
end
