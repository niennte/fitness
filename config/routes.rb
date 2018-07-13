Rails.application.routes.draw do
  resources :activities
  devise_for :users, :controllers => { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  get '/summary', to: 'activities#summary'
end



