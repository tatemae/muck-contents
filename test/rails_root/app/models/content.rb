# == Schema Information
#
# Table name: contents
#
#  id               :integer         not null, primary key
#  creator_id       :integer
#  title            :string(255)
#  body             :text
#  locale           :string(255)
#  body_raw         :text
#  contentable_id   :integer
#  contentable_type :string(255)
#  parent_id        :integer
#  lft              :integer
#  rgt              :integer
#  is_public        :boolean
#  state            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  layout           :string(255)
#  comment_count    :integer         default(0)
#

class Content < ActiveRecord::Base
  acts_as_muck_content(
    :git_repository => GlobalConfig.content_git_repository,
    :enable_auto_translations => GlobalConfig.enable_auto_translations,
    :enable_solr => GlobalConfig.content_enable_solr
  )
end
