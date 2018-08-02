Rails.application.routes.draw do
  resources :activities
  devise_for :users, :controllers => { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  get '/about', to: 'welcome#about'
  get '/summary', to: 'activities#summary'
  get '/summary-all', to: 'activities#summary_all'
  get '/list', to: 'activities#list'
end



