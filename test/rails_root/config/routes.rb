ActionController::Routing::Routes.draw do |map|
  map.home '', :controller => 'default', :action => 'index'
  map.root :controller => 'default', :action => 'index'
  map.resources :users, :has_many => :contents, :has_many => :uploads
  map.resources :uploads, :collection => { :photos => :get, :multiupload => :post }
end
