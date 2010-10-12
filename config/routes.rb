Rails.application.routes.draw do
  resources :contents, :controller => 'muck/contents'
  resources :contents_missing, :controller => 'muck/contents_missing'
  match '/tiny_mce_files' => 'muck/tiny_mce#tiny_mce_files', :as => :tiny_mce_files
  match '/tiny_mce_images' => 'muck/tiny_mce#tiny_mce_images', :as => :tiny_mce_images
  match '/tiny_mce_links' => 'muck/tiny_mce#tiny_mce_links', :as => :tiny_mce_links
  match '/tiny_mce_flickr' => 'muck/tiny_mce#tiny_mce_flickr', :as => :tiny_mce_flickr

  match '/images_for_content' => 'muck/tiny_mce#images_for_content', :as => :images_for_content
  match '/files_for_content' => 'muck/tiny_mce#files_for_content', :as => :files_for_content
  match '/links_for_content' => 'muck/tiny_mce#links_for_content', :as => :links_for_content
end
