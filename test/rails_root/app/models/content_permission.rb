# == Schema Information
#
# Table name: content_permissions
#
#  id         :integer         not null, primary key
#  content_id :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class ContentPermission < ActiveRecord::Base
  acts_as_muck_content_permission
end
