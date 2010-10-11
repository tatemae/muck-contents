module MuckContents
  
  def self.configuration
    # In case the user doesn't setup a configure block we can always return default settings:
    @configuration ||= Configuration.new
  end
  
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    
    attr_accessor :content_git_repository     # Not currently used.  Eventually this will be the path to a git repository that the content system uses to store revisions.
    attr_accessor :enable_auto_translations   # If true then all content objects will automatically be translated into all languages supported by Google Translate
    attr_accessor :enable_solr                # Enables solr for the content system.  If you are using solr then set this to true.  If you do not wish to setup and manage solr 
                                              # then set this value to false (but search will be disabled).
    attr_accessor :content_css                # CSS files that should be fed into the tiny_mce content editor.  
                                              # Note that Rails will typically generate a single all.css stylesheet.  Setting the stylesheets here let's 
                                              # the site administrator control which css is present in the content editor and thus which css an end 
                                              # user has access to to style their content.
    attr_accessor :flickr_api_key             # Not currently used but will be used to load pictures from a flickr account so they can be inserted into a document.
    attr_accessor :sanitize_content           # Leave this one on or suffer hacker wrath.
    attr_accessor :enable_comments            # Turns comments on and off for a content page.
    
    def initialize
      self.sanitize_content = true
      self.enable_auto_translations = true
      self.enable_solr = false
      self.enable_comments = false
      self.git_repository = nil #"#{File.join(RAILS_ROOT, 'repo', RAILS_ENV)}"
      self.content_css = ['/stylesheets/reset.css', '/stylesheets/styles.css']
    end
    
  end
end