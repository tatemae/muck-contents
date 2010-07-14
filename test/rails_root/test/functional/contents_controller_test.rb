require File.dirname(__FILE__) + '/../test_helper'

class Muck::ContentsControllerTest < ActionController::TestCase

  tests Muck::ContentsController
  
  context "content controller" do
    setup do
      @user = Factory(:user)
      @content = Factory(:content, :contentable => @user)
    end
    
    context "GET show" do
      setup do
        get :show, :id => @content.to_param, :scope => Content.contentable_to_scope(@user)
      end
      should_respond_with :success
      should_render_template :show
    end
    
    context "GET show nested" do
      setup do
        @nested_content = Factory.build(:content, :contentable => nil)
        @nested_content.uri = '/a/test/the_blue_one'
        @nested_content.save!
        get :show, :id => @nested_content.to_param, :scope => @nested_content.scope
      end
      should_respond_with :success
      should_render_template :show
    end
    
    context "GET show using parent" do
      setup do
        get :show, make_parent_params(@user).merge(:id => @content.to_param)
      end
      should_respond_with :success
      should_render_template :show
    end
    
    context "logged in" do
      
      setup do
        @admin = Factory(:user)
        @admin_role = Factory(:role, :rolename => 'administrator')
        @admin.roles << @admin_role
        activate_authlogic
        login_as @admin
      end
      
      context "GET new" do
        setup do
          @path = '/a/test/path'
          @file = 'file'
          get :new, :path => File.join(@path, @file)
        end
        should_respond_with :success
        should_render_template :new
        should "setup content object uri_path" do
          assert_equal @path, assigns(:content).uri_path
        end
      end
    
      context "POST create" do
        setup do
        end
      end
    
      context "PUT update" do
        setup do
        end
      end
    
      context "DELETE destroy" do
        context "html" do
          setup do
            delete :destroy, :id => @content.id
          end
          should_respond_with :redirect
          should_set_the_flash_to I18n.t('muck.contents.content_removed') 
        end
        context "js" do
          setup do
            delete :destroy, :id => @content.id, :format => 'js'
          end
          should_respond_with :success
        end
        context "json" do
          setup do
            delete :destroy, :id => @content.id, :format => 'json'
          end
          should_respond_with :success
          should "indicate success in the json" do
            assert @response.body.include?(I18n.t("muck.contents.content_removed"))
          end
        end
      end
      
    end
  end
end
