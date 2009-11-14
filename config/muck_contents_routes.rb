ActionController::Routing::Routes.draw do |map|
  map.resources :contents, :controller => 'muck/contents'
  map.tiny_mce_files '/tiny_mce_files', :controller => 'tiny_mce', :action => 'tiny_mce_files'
  map.tiny_mce_images '/tiny_mce_images', :controller => 'tiny_mce', :action => 'tiny_mce_images'
  
  # MuckContents.routes.each do |route|
  #   map.connect route[:uri], MuckContents.build_route_options(route)
  # end
  
end
