#include MuckContents::Models::MuckContentHandler
module MuckContents
  module Models
    module MuckContentHandler
      
      protected
  
        def handle_content_request
          get_content
          if @content.blank?
            redirect_to new_content_path(:path => env["muck_contents.request_uri"])
          else
            return if ensure_current_url
            render_show_content
          end
        end
  
        # Renders the show template with the current content.
        def render_show_content
          activate_authlogic # HACK authlogic isn't turned on for the application controller so we force it.  See http://www.mrkris.com/2009/08/21/authlogic-and-rescue_from-actioncontroller-routingerror/
          @page_title = @content.locale_title(I18n.locale)
          respond_to do |format|
            format.html do
              if @content.layout.blank?
                render :template => 'contents/show'
              else
                render :template => 'contents/show', :layout => @content.layout
              end
            end
            format.xml  { render :xml => @content }
          end
        end
  
        # Checks to see if the content has a better url.  If it does a redirect is performed and true is returned.
        # If not redirect then false is returned.
        def ensure_current_url
          # TODO right now in the routes we setup each page to be found via numeric id which triggers has_better_id?
          # In addition url_for(@content) adds 'contents' to the path.  Need to figure out how to generate the uri
          # when url_for(@content) is called or change to @content.uri and how to take advantage of the slug history which
          # helps us setup permanent redirects
          if !@content.friendly_id_status.best?
            redirect_to @content, :status => :moved_permanently
            true
          else
            false
          end
        end

        # Tries to find content using parameters from the url
        def get_content
          return if @content # in case @content is setup by an overriding method
          id = params[:id] || Content.id_from_uri(env["muck_contents.request_uri"])
          scope = params[:scope] || Content.scope_from_uri(env["muck_contents.request_uri"]) 
          @content = Content.find(id, :scope => scope) rescue nil
          if @content.blank?
            @contentable = get_parent
            if @contentable
              @content = Content.find(params[:id], :scope => Content.contentable_to_scope(@contentable)) rescue nil
            end
          end
        end
        
    end
  end
end