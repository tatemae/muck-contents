# include MuckContents::Models::MuckContentTranslation
module MuckContents
  module Models
    module MuckContentTranslation
     
      extend ActiveSupport::Concern
      
      included do      
        belongs_to :content
        
        scope :by_newest, order("content_translations.created_at DESC")
        scope :newer_than, lambda { |*args| where("content_translations.created_at > ?", args.first || 1.week.ago) }
        scope :by_alpha, order("content_translations.title ASC")
        scope :by_locale, lambda { |locale| where('content_translations.locale = ?', locale) }

        attr_protected :created_at, :updated_at
        
      end

    end
  end
end
