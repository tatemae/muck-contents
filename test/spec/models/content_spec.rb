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

require File.dirname(__FILE__) + '/../spec_helper'

# Used to test muck_content
describe Content do

  describe "content" do
    before(:all) do
      @title = 'hello'
      @body = 'hello world'
      @creator = Factory(:user)
      @content = Factory(:content, :title => @title, :body_raw => @body, :creator => @creator)
      @aaron = Factory(:user)
      @quentin = Factory(:user)
      @admin = Factory(:user)
      @admin.add_to_role('administrator')
      @editor = Factory(:user)
      @editor.add_to_role('editor')
      @user = Factory(:user)
    end
    
    it { should belong_to :contentable }
    it { should belong_to :creator }
    it { should have_many :content_permissions }
    it { should have_many :content_translations }
    
    it { should validate_presence_of :title  }
    it { should validate_presence_of :body_raw }
    it { should validate_presence_of :locale }
    
    it { should scope_by_newest }
    it { should scope_newer_than }
    it { should scope_is_public }
    it { should scope_by_title }
    it { should scope_by_creator }
    
    describe "sanitize" do
      before do
        @content = Factory(:content)
      end
      it "should sanitize user input fields" do
        @content.should sanitize(:title)
        @content.should sanitize(:body)
      end
    end
    
    describe "named scopes" do
      before(:each) do
        @creator = Factory(:user)
        @content = Factory(:content, :creator => @creator)
        @other_content = Factory(:content)
        @contentable = Factory(:content, :contentable => @creator)
        @no_contentable = Factory(:content, :contentable => nil)
        @custom_scope = '/something-custom'
        @content_with_custom_scope = Factory(:content, :custom_scope => @custom_scope)
      end
      describe "no_contentable" do
        before(:each) do
          @user = Factory(:user)
          @content_not = Factory(:content, :contentable => nil)
          @content = Factory(:content, :contentable => @user)
        end
        it "should not find content with contentable association" do
          Content.no_contentable.should_not include(@content)
        end
        it "should find content without contentable association" do
          Content.no_contentable.should include(@content_not)
        end
      end
      describe "by_scope" do
        it "should find content by scope" do
          Content.by_scope(@custom_scope).should include(@content_with_custom_scope)
        end
        it "should not find content not in scope" do
          Content.by_scope(@custom_scope).should_not include(@content)
        end
      end      
      describe "by_parent" do
        before(:each) do
          Content.delete_all
          @parent_content = Factory(:content)
          @item = Factory(:content, :parent => @parent_content)
          @item1 = Factory(:content)
        end
        it "should find items by the source they are associated with" do
          items = Content.by_parent(@parent_content)
          items.should include(@item)
          items.should_not include(@item1)
        end
      end
      describe "by_parent" do
        before(:each) do
          @parent_content = Factory(:content)
          @content.move_to_child_of(@parent_content)
        end
        it "should find by parent object" do
          Content.by_parent(@parent_content).should include(@content)
        end
        it "should not find content" do
          Content.by_parent(@parent_content).should_not include(@other_content)
        end
      end
      describe "by_creator" do
        it "should find by creator" do
          Content.by_creator(@creator).should include(@content)
        end
        it "should not find content" do
          Content.by_creator(@creator).should_not include(@other_content)
        end
      end
      describe "no_contentable" do
        it "should find content without contentable" do
          Content.no_contentable.should include(@no_contentable)
        end
        it "should not find content with contentable" do
          Content.no_contentable.should_not include(@contentable)
        end
      end
    end

    describe "enable_auto_translations" do
      it "should auto translate the content" do
        original_enable_auto_translations = MuckContents.configuration.enable_auto_translations
        MuckContents.configuration.enable_auto_translations = true
        translated_content = Factory.build(:content, :title => @title, :body_raw => @body, :creator => @creator)
        translated_content.should_receive(:auto_translate)
        translated_content.save!
        MuckContents.configuration.enable_auto_translations = original_enable_auto_translations
      end
    end
    
    describe "translations" do
      before(:all) do
        @original_enable_auto_translations = MuckContents.configuration.enable_auto_translations
        MuckContents.configuration.enable_auto_translations = true
        @translated_content = Factory.build(:content, :title => 'hello', :body_raw => 'hello world')
        @translated_content.save!
      end
      after(:all) do
        MuckContents.configuration.enable_auto_translations = @original_enable_auto_translations
      end
      it "should have localized title" do
        @translated_content.locale_title('es').should == 'hola'
      end
      it "should have localized body" do
        @translated_content.locale_body('es').should == 'hola mundo'
      end
      it "should give back title" do
        @translated_content.locale_title('en').should == @title
      end
      it "should give back body" do
        @translated_content.locale_body('en').should == @body
        @translated_content.body.should == @body
      end
      it "should get a specific translation" do
        translation = @translated_content.translation_for('es')
        translation.title.should == 'hola'
      end
      describe "edited" do
        before do
          @translation = @translated_content.content_translations.first
          @translation.title = 'junk'
          @translation.user_edited = true
          @translation.save!
        end
        it "should not change user edited translations" do
          @translated_content.translate(false)
          @translation.reload
          @translation.title.should == 'junk'
        end
        it "should change user edited translations" do
          @translated_content.translate(true)
          @translation.reload
          @translation.title.should_not == 'junk'
        end
      end
    end
  
    describe "uri" do
      describe "global content (contentable is nil)" do
        before(:each) do
          @path = '/a/test/path'
          @key =  'key'
          @content = Factory.build(:content, :contentable => nil)
          @content.uri = File.join(@path, @key)
          @content.save!
        end
        it "should set uri_path" do
          @content.uri_path.should == @path
        end
        it "should set key for path" do
          @content.title.should == @key.titleize
        end
        it "should set get_content_scope to '/a/test/path' for use as scope in friendly_id" do
          @content.get_content_scope.should == @path
        end
        it "should get uri based on path" do
          @content.uri.should == File.join(@path, @key)
        end
        describe "setup_uri_path" do
          it "should load uri_path" do
            @content = Content.find(@content.id) # Reload the content. Note that @content.reload doesn't work here.
            @content.uri_path.should == nil
            @content.setup_uri_path
            @content.uri_path.should == @path
          end
        end
      end
      describe "content with contentable" do
        before(:each) do
          @user = Factory(:user)
          @content = Factory(:content, :contentable => @user)
        end
        it "should set the uri using contentable" do
          @content.uri.should == File.join('/', @user.class.to_s.tableize, @user.to_param, @content.to_param)
        end
      end
      describe "invalid content uri" do
        before(:each) do
          @content = Factory.build(:content, :contentable => nil)
        end
        it "should indicate uri is not valid" do
          @content.should_not be_valid_uri
        end
      end
      # TODO valid? is throwing exceptions even before save.
      # Uncomment test if valid? is added back into muck_content.rb
      # it "should require uri if contentable is nil" do
      #   lambda{
      #     u = Factory.build(:content, :contentable => nil)
      #     u.should_not be_valid
      #     u.errors.should_not be_blank
      # }.should change(Content, :count)
      # end
    end
  
    describe "singleton methods" do
      before(:each) do
        @user = Factory(:user)
      end
      it "should build path based on user object" do
        Content.contentable_to_scope(@user).should == "/users/#{@user.to_param}"
      end
    end
    
    describe "search" do
    end
  
    describe "tags" do
      before(:each) do
        @other_content = Factory(:content)
        @content.tag_list = 'test'
        @content.save!
      end
      it "should find by tag" do
        Content.tagged_with('test', :on => :tags).should include(@content)
      end
      it "should not find content" do
        Content.tagged_with('test', :on => :tags).should_not include(@other_content)
      end
    end

    describe "sanitize" do
      describe "as admin" do
        before do
          @content.current_editor = @admin
        end
        it "should not sanitize" do
          @content.sanitize_level.should == nil
        end
      end
      describe "as editor" do
        before do
          @content.current_editor = @editor
        end
        it "should have relaxed sanitize" do
          @content.sanitize_level.should == Sanitize::Config::RELAXED
        end
      end
      describe "as user" do
        before do
          @content.current_editor = @user
        end
        it "should have basic sanitize" do
          @content.sanitize_level.should == Sanitize::Config::BASIC
        end
      end
    end
  
    describe "current editor" do
      before(:each) do
        @creator = Factory(:user)
        @content = Factory(:content, :creator => @creator)
        @current_editor = Factory(:user)
      end
      it "should return creator as the content editor" do
        @content.current_editor.should == @creator
      end
      it "should set current editor" do
        @content.current_editor = @current_editor
        @content.current_editor.should == @current_editor
      end
    end
  
    describe "permissions" do
      describe "admin" do
        it "should be able to edit content" do
          @content.can_edit?(@admin).should be_true
        end
      end
      describe "editor" do
        it "should be able to edit content" do
          @content.can_edit?(@editor).should be_true
        end
      end
      describe "creator" do
        it "should be able to edit content" do
          @content.can_edit?(@creator).should be_true
        end
      end
      describe "other user" do
        it "should not be able to edit content" do
          @content.can_edit?(@aaron).should be_false
        end
      end
      it "should give permissions" do
        @content.can_edit?(@aaron).should be_false
        @content.can_edit?(@quentin).should be_false
        @content.allow_edit(@aaron)
        @content.can_edit?(@aaron).should be_true, "Aaron was not given edit permissions"
        @content.allow_edit(@quentin)
        @content.can_edit?(@quentin).should be_true, "Quentin was not given edit permissions"
      end
      it "should remove permissions" do
        @content.allow_edit(@quentin)
        @content.allow_edit(@aaron)
        @content.can_edit?(@aaron).should be_true
        @content.disallow_edit(@aaron)
        @content.can_edit?(@aaron).should be_false
        @content.can_edit?(@quentin).should be_true, "Quentin's permissions were removed along with Aaron's but should not have been." 
      end
      it "should not add the same permission multple times" do
        @content.content_permissions.delete_all
        @content.allow_edit(@aaron)
        @content.allow_edit(@aaron)
        @content.content_permissions.count.should == 1
      end
    end
  end
  
end
