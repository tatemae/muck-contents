# include MuckContents::Controllers::MuckContentHandler
class Muck::ContentsMissingController < ApplicationController
  include MuckContents::Models::MuckContentHandler
  
  # Renders content, shows 404 or redirects to new content as appropriate
  def index
    handle_content_request
  end

end