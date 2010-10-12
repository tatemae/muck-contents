require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::ContentsMissingController do
  
  render_views
  
  before do
    @user = Factory(:user)
    @content = Factory(:content, :contentable => @user, :uri => '/a/test')
  end
  
  describe "index" do
    describe "page exists" do
      before do
        @env = {}
        @env["muck_contents.request_uri"] = @content.uri
        controller.stub!(:env).and_return(@env)
        get :index
      end
      it { should respond_with :success }
      it { should render_template :show }
    end
    describe "page doesn't exist" do
      before do
        @env = {}
        @env["muck_contents.request_uri"] = '/test_page'
        controller.stub!(:env).and_return(@env)
        get :index
      end
      it { should redirect_to new_content_path(:path => '/test_page') }
    end
  end
  
end