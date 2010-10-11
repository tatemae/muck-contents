RailsTest::Application.routes.draw do
  root :to => "default#index"
  
  resources :users do
    resources :comments
  end
  
  match ':controller(/:action(/:id(.:format)))'
end
