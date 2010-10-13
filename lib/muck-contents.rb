require 'friendly_id'
require 'acts-as-taggable-on'
require 'tiny_mce'
require 'sanitize'
require 'babelphish'
require 'uploader'

require 'muck-contents/config.rb'
require 'muck-contents/rack/rack.rb'
require 'muck-contents/models/content.rb'
require 'muck-contents/models/content_permission.rb'
require 'muck-contents/models/content_translation.rb'
require 'muck-contents/controllers/content_handler.rb'
require 'muck-contents/engine.rb'

module MuckContents
  GLOBAL_SCOPE = '/'
end