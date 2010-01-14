module TinymceHelper
  
  # Pass paths into the tiny mce image, link and file dialog via hidden fields
  # options:
  #       tiny_mce_files_width: width of file dialog. Default is 675
  #       tiny_mce_files_height: height of file dialog. Default is 540
  #       tiny_mce_images_width: width of image dialog. Default is 675
  #       tiny_mce_images_height height of image dialog. Default is 540
  def mce_fields(parent, options = {})
    parent_params = make_muck_parent_fields(parent) || {}
    files_path = tiny_mce_files_url(parent_params)
    images_path = tiny_mce_images_url(parent_params)
    links_path = tiny_mce_links_url(parent_params)
    flickr_path = tiny_mce_flickr_url(parent_params)
    
    %Q{<input id="tiny_mce_files_path" type="hidden" value="#{files_path}">
    <input id="tiny_mce_files_width" type="hidden" value="#{options[:tiny_mce_files_width] || 675}">
    <input id="tiny_mce_files_height" type="hidden" value="#{options[:tiny_mce_files_height] || 540}">
    <input id="tiny_mce_images_path" type="hidden" value="#{images_path}">
    <input id="tiny_mce_images_width" type="hidden" value="#{options[:tiny_mce_images_width] || 675}">
    <input id="tiny_mce_images_height" type="hidden" value="#{options[:tiny_mce_images_height] || 560}">
    <input id="tiny_mce_links_path" type="hidden" value="#{links_path}">
    <input id="tiny_mce_links_width" type="hidden" value="#{options[:tiny_mce_links_width] || 480}">
    <input id="tiny_mce_links_height" type="hidden" value="#{options[:tiny_mce_links_height] || 480}">
    <input id="tiny_mce_flickr_path" type="hidden" value="#{flickr_path}">
    <input id="tiny_mce_flickr_width" type="hidden" value="#{options[:tiny_mce_flickr_width] || 675}">
    <input id="tiny_mce_flickr_height" type="hidden" value="#{options[:tiny_mce_flickr_height] || 675}">}
  end
  
  # Output a form capable of uploading files to the server.
  # This method is a wrapper for the upload_form found in the uploader gem.
  # parent: The object to which the uploads will be attached
  # display_upload_indicators: Indicates whether or not to show the upload progress
  # container_prefix: Prefixes each id in the html with the specified text.  Useful if there is to be more than one form on a page.
  # options: Options to pass to the swf javascript for setting up the swfupload object:
  #     upload_url:             Url to upload to.  Default is '<%= new_upload_path_with_session_information(parent) %>'
  #     file_size_limit:        Largest allowable file size.  Default is '100 MB'
  #     file_types:             Allowed file types.  Default is "*.*"
  #     file_types_description: Description for file types.  Default is "All Files"
  #     file_upload_limit:      Maximum number of files per upload.  Default is 100
  #     button_image_url:       Url of button image to use for swf upload.  Default is "/images/SWFUploadButton.png"
  #     button_width:           Width of the image button being used.  Default is 61
  #     button_height:          Height of the button being used.  Default is 22
  #     transparent:            Turns the swfupload transparent so you can use the html behind it for the upload button.  
  #                             This will override any settings provided for button_image_url
  #     transparent_html:       If transparent is true this html will be rendered under the transparent swfupload button.
  def tiny_mce_upload_form(parent, display_upload_indicators = true, container_prefix = '', options = {})
    upload_form(parent, display_upload_indicators, container_prefix, {:upload_url =>new_upload_path_with_session_information(parent, 'json')}.merge(options))
  end
  
  # Renders script required for a single tinymce editor on a page.  This script will enable
  # the save button in the editor and include tinymce scripts if needed.
  # If the page contains multiple editors call this method one time for each editor
  # passing in the id.
  # form_id:              id of form containing editor.
  # mce_id:               id of tiny mce editor 
  # message_container_id: id of a container for returned messages
  # message_id:           id of the container for the actual message
  # include_save_page:    This script is used include or omit the 'save_page' javascript.  Set to true if the editor includes a save button.
  def tiny_mce_scripts(options = {})
    options[:include_save_page] = true unless options.has_key?(:include_save_page)
    render :partial => 'tiny_mce/tiny_mce_scripts', :locals => options
  end
  
  # Adds fields for outputing messages related to the tiny mce editor.
  # This method is used instead of tiny_mce_scripts if no customization of message fields
  # is required.
  # mce_id:   id of tiny mce editor 
  # parent:   parent object for which to build tiny mce editor
  def tiny_mce_messages_and_scripts_for(mce_id, parent)
    form_id = "#{parent.dom_id}_content_form"
    message_container_id = "#{parent.dom_id}_message_container"
    message_id = "#{parent.dom_id}_message"
    render :partial => 'tiny_mce/tiny_mce_messages_and_scripts_for', :locals => { :mce_id => mce_id,
                                                                                  :form_id => form_id,
                                                                                  :message_container_id => message_container_id,
                                                                                  :message_id => message_id }
  end

  # Adds tiny mce intialization code if it hasn't already been added.
  def init_tiny_mce
    return if @@init_tiny_mce_completed
    @@init_tiny_mce_completed = true
    render :partial => 'tiny_mce/init_tiny_mce'
  end
  
end