Rails.application.routes.draw do
  scope "(:locale)", locale: /en|ja|vi/, defaults: { locale: "en" } do
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    root "static_pages#home"
    get "help", to: "static_pages#help"

    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    resources :users
    resources :password_resets, only: %i(new create edit update)
    resources :account_activations, only: :edit
    resources :microposts, only: %i(create destroy)
  end
end
