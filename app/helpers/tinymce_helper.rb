module TinymceHelper
  
  # Pass paths into the tiny mce image and file dialog via hidden fields
  # auto_complete_pages_path is for the tinymce link dialog.  It will use that value to 
  # retrieve a list of content pages to link to
  def mce_fields(parent)
    if parent.blank?
      path = contents_path(:format => 'json')
    else
      path = new_upload_path_with_session_information(parent)
    end
    %Q{<input id="upload-path" type="hidden" value="#{path}"> 
       <input id="session-key" type="hidden" value="#{GlobalConfig.session_key}">
       <input id="session-id" type="hidden" value="#{request.session_options[:id]}">}
  end
  
end