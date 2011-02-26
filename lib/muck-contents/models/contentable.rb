# include MuckContents::Models::MuckContentable
module MuckContents
  module Models
    module MuckContentable
      extend ActiveSupport::Concern
    
      included do
        has_many :contents, :as => :contentable, :dependent => :destroy
      end
      
    end
    
  end
end