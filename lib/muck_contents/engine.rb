require 'muck_contents'
require 'rails'

module MuckContents
  class Engine < ::Rails::Engine
    
    def muck_name
      'muck-contents'
    end
    
    initializer 'muck_contents.helpers' do |app|
      ActiveSupport.on_load(:action_view) do
        include MuckContentsHelper
        include TinymceHelper
      end
    end
    
    initializer 'muck_contents.controllers' do |app|
      ActiveSupport.on_load(:action_controller) do
        include MuckContents::Controllers::MuckContentHandler
      end
    end
    
    initializer 'muck_contents.i18n' do |app|
      ActiveSupport.on_load(:i18n) do
        I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', '..', 'config', 'locales', '*.{rb,yml}') ]
      end
    end
        
  end
end
