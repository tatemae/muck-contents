# == Schema Information
#
# Table name: uploads
#
#  id                  :integer         not null, primary key
#  creator_id          :integer
#  name                :string(255)
#  caption             :string(1000)
#  description         :text
#  is_public           :boolean         default(TRUE)
#  uploadable_id       :integer
#  uploadable_type     :string(255)
#  width               :string(255)
#  height              :string(255)
#  local_file_name     :string(255)
#  local_content_type  :string(255)
#  local_file_size     :integer
#  local_updated_at    :datetime
#  remote_file_name    :string(255)
#  remote_content_type :string(255)
#  remote_file_size    :integer
#  remote_updated_at   :datetime
#  created_at          :datetime
#  updated_at          :datetime
#

class Upload < ActiveRecord::Base
  
  include Uploader::Models::Upload

  acts_as_taggable
  
  scope :is_public, :conditions => "is_public = true"
  scope :tagged_with, lambda {|tag_name| where("tags.name = ?", tag_name).includes(:tags) }
  
end
