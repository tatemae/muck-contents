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
        describe "html" do
          before do
            get :index
          end
          it { should respond_with :success }
          it { should render_template :index }
        end
        describe "json" do
          before do
            @content = Factory(:content, :title => 'my test doc')
            get :index, :format => 'json', :term => 'my'
          end
          it { should respond_with :success }
          it "should include the searched for content" do
            @response.body.should include(@content.title)
          end
        end
      end    
      
      describe "DELETE destroy" do
        before do
          @user = Factory(:user)
          @content = Factory(:content, :contentable => @user)
        end
        describe "html" do
          before do
            delete :destroy, :id => @content.id
          end
          it { should respond_with :redirect }
          it { should set_the_flash.to(I18n.t('muck.contents.content_removed')) }
        end
        describe "js" do
          before do
            delete :destroy, :id => @content.id, :format => 'js'
          end
          it { should respond_with :success }
        end
        describe "json" do
          before do
            delete :destroy, :id => @content.id, :format => 'json'
          end
          it { should respond_with :success }
          it "should indicate success in the json" do
            @response.body.should include(I18n.t("muck.contents.content_removed"))
          end
        end
      end
      
    end
  end
end
