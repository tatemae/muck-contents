# == Schema Information
#
# Table name: comments
#
#  id               :integer         not null, primary key
#  commentable_id   :integer         default(0)
#  commentable_type :string(15)      default("")
#  body             :text
#  user_id          :integer
#  parent_id        :integer
#  lft              :integer
#  rgt              :integer
#  is_denied        :integer         default(0), not null
#  is_reviewed      :boolean
#  created_at       :datetime
#  updated_at       :datetime
#

class Comment < ActiveRecord::Base
  
  acts_as_muck_comment
  
end
