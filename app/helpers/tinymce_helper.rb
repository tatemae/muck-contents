module TinymceHelper
  
  # Pass paths into the tiny mce image, link and file dialog via hidden fields
  # options:
  #       tiny_mce_files_width: width of file dialog.  Default is 675
  #       tiny_mce_files_height: height of file dialog.  Default is 540
  def mce_fields(parent, options = {})
    parent_params = make_muck_parent_fields(parent) || {}
    tiny_mce_files_path = tiny_mce_files_url(parent_params)
    tiny_mce_images_path = tiny_mce_images_url(parent_params)
    tiny_mce_links_path = tiny_mce_links_url(parent_params)
    
    %Q{<input id="tiny_mce_files_path" type="hidden" value="#{tiny_mce_files_path}">
    <input id="tiny_mce_files_width" type="hidden" value="#{options[:tiny_mce_files_width] || 675}">
    <input id="tiny_mce_files_height" type="hidden" value="#{options[:tiny_mce_files_height] || 540}">
    <input id="tiny_mce_images_path" type="hidden" value="#{tiny_mce_images_path}">
    <input id="tiny_mce_links_path" type="hidden" value="#{tiny_mce_links_path}">}
  end
  
  def tiny_mce_upload_form(parent)
    upload_form(parent, true, '', :upload_url =>new_upload_path_with_session_information(parent, 'json'))
  end
    
end