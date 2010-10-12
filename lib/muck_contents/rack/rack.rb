module MuckContents
  module Routing
    class Rack
      def initialize(app)
        @app = app
      end

      def call(env)
        env["action_dispatch.show_exceptions"] = false
        @app.call(env)
      rescue => exception
        if exception.kind_of?(ActionController::RoutingError)
          request_type = File.extname(env["REQUEST_URI"]).gsub('.','').downcase
          # HACK. We can't rely on request.format when the request comes from ie.
          # request.format.html? can actually give a false result on ie so try the file extension
          # Requests to the content system won't have a file extension so request_type should be empty
          if request_type.empty?
            env["muck_contents.request_uri"] = env["REQUEST_URI"].gsub("http://#{env["HTTP_HOST"]}", '')
            env["PATH_INFO"] = env["REQUEST_URI"] = "/contents_missing"
          end
        end
        
        env["action_dispatch.show_exceptions"] = true
        return @app.call(env)
      end
    end
  end
end



