module TinymceHelper
  
  # Pass paths into the tiny mce image and file dialog via hidden fields
  # auto_complete_pages_path is for the tinymce link dialog.  It will use that value to 
  # retrieve a list of content pages to link to
  def mce_fields(upload_path, auto_complete_pages_path)
    '<input id="upload-path" type="hidden" value="' + upload_path + '">' + 
    '<input id="pages-path" type="hidden" value="' + auto_complete_pages_path + '">' + 
    '<input id="session-key" type="hidden" value="' + GlobalConfig.session_key + '">' + 
    '<input id="session-id" type="hidden" value="' + session.session_id + '">'
  end
  
end