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

require File.dirname(__FILE__) + '/../spec_helper'

# Used to test muck_content_permission
describe ContentPermission do

  describe "A content permission instance" do
    before do
      @content_permission = Factory(:content_permission)
    end
    
    it { should belong_to :content }
    it { should belong_to :user }
    
    describe "Get permission by user" do
      before do
        @user_with_permission = Factory(:user)
        @user_no_permission = Factory(:user)
        Factory(:content_permission, :user => @user_with_permission)
      end
      it "should find user with permissions" do
        ContentPermission.by_user(@user_with_permission).map(&:user_id).include?(@user_with_permission.id)
      end
      it "should not find user without permissions" do
        assert ContentPermission.by_user(@user_no_permission).blank?
      end
    end
    
  end
  
end
