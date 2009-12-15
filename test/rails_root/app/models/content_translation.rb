# == Schema Information
#
# Table name: content_translations
#
#  id          :integer         not null, primary key
#  content_id  :integer
#  title       :string(255)
#  body        :text
#  locale      :string(255)
#  user_edited :boolean
#  created_at  :datetime
#  updated_at  :datetime
#

class ContentTranslation < ActiveRecord::Base
  acts_as_muck_content_translation
end
