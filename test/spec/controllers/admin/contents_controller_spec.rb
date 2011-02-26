require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::Muck::ContentsController do

  render_views
  
  it { should require_login :index, :get }
  
  describe "admin content controller" do
        
    describe "logged in as admin" do
      
      before do
        @admin = Factory(:user)
        @admin_role = Factory(:role, :rolename => 'administrator')
        @admin.roles << @admin_role
        activate_authlogic
        login_as @admin
      end
      
      describe "GET index" do
        before do
          get :index
        end
        it { should respond_with :success }
        it { should render_template :index }
      end    
      
    end
  end
end
