ActionController::Routing::Routes.draw do |map|
  map.resources :contents, :controller => 'muck/contents'
  map.tiny_mce_files '/tiny_mce_files', :controller => 'muck/tiny_mce', :action => 'tiny_mce_files'
  map.tiny_mce_images '/tiny_mce_images', :controller => 'muck/tiny_mce', :action => 'tiny_mce_images'
  map.tiny_mce_links '/tiny_mce_links', :controller => 'muck/tiny_mce', :action => 'tiny_mce_links'
  
  map.images_for_content '/images_for_content', :controller => 'muck/tiny_mce', :action => 'images_for_content'
  map.files_for_content '/files_for_content', :controller => 'muck/tiny_mce', :action => 'files_for_content'
  map.links_for_content '/links_for_content', :controller => 'muck/tiny_mce', :action => 'links_for_content'
  
  # MuckContents.routes.each do |route|
  #   map.connect route[:uri], MuckContents.build_route_options(route)
  # end
  
end
