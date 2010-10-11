require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::ContentsController do
  
  describe "content controller" do
    before do
      @user = Factory(:user)
      @content = Factory(:content, :contentable => @user)
    end
    
    describe "GET show" do
      before do
        get :show, :id => @content.to_param, :scope => Content.contentable_to_scope(@user)
      end
      it { should respond_with :success }
      it { should render_template :show }
    end
    
    describe "GET show nested" do
      before do
        @nested_content = Factory.build(:content, :contentable => nil)
        @nested_content.uri = '/a/test/the_blue_one'
        @nested_content.save!
        get :show, :id => @nested_content.to_param, :scope => @nested_content.scope
      end
      it { should respond_with :success }
      it { should render_template :show }
    end
    
    describe "GET show using parent" do
      before do
        get :show, make_parent_params(@user).merge(:id => @content.to_param)
      end
      it { should respond_with :success }
      it { should render_template :show }
    end
    
    describe "logged in" do
      
      before do
        @admin = Factory(:user)
        @admin_role = Factory(:role, :rolename => 'administrator')
        @admin.roles << @admin_role
        activate_authlogic
        login_as @admin
      end
      
      describe "GET new" do
        before do
          @path = '/a/test/path'
          @file = 'file'
          get :new, :path => File.join(@path, @file)
        end
        it { should respond_with :success }
        it { should render_template :new }
        it "should setup content object uri_path" do
          assigns(:content).uri_path.should == @path
        end
      end
    
      describe "POST create" do
        before do
        end
      end
    
      describe "PUT update" do
        before do
        end
      end
    
      describe "DELETE destroy" do
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
