# include MuckContents::Models::MuckContentPermission
module MuckContents
  module Models
    module MuckContentPermission
      
      extend ActiveSupport::Concern
      
      included do
        belongs_to :content
        belongs_to :user

        scope :by_user, lambda { |user| where('content_permissions.user_id = ?', user.id) }
        attr_protected :created_at, :updated_at

      end
      
    end
  end
end
