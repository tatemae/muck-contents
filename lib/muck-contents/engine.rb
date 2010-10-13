require 'muck-contents'
require 'rails'

module MuckContents
  class Engine < ::Rails::Engine
    
    def muck_name
      'muck-contents'
    end
    
    config.app_middleware.insert_before("ActionDispatch::ShowExceptions", "MuckContents::Routing::Rack")
    
    initializer 'muck-contents.helpers' do |app|
      ActiveSupport.on_load(:action_view) do
        include MuckContentsHelper
        include TinymceHelper
      end
    end
    
    initializer 'muck-contents.i18n' do |app|
      ActiveSupport.on_load(:i18n) do
        I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', '..', 'config', 'locales', '*.{rb,yml}') ]
      end
    end
        
  end
end
