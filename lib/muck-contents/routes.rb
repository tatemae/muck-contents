module MuckContents
  module Routes
    extend ActiveSupport::Concern
    
    included do
      add_routes
    end
    
    def add_routes
      routes.each do |route|
        match route[:uri] => 'contents#show', :defaults => { :id => route[:id], :scope => route[:scope] }
      end
    end
    
    def routes
      content_routes = []
      contents = Content.no_contentable.find(:all, :include => 'slugs')
      contents.each do |content|
        content_route = { :uri => content.uri,
                          :scope => content.scope,
                          :id => content.id }
        if !content_routes.include?(content_route)
          content_routes << content_route
        end
      end
      content_routes
    end
    
  end
end

module ActionDispatch::Routing
  class Mapper #:nodoc:
    include MuckContents::Routes
  end
end

