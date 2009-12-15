# == Schema Information
#
# Table name: content_translations
#
#  id          :integer         not null, primary key
#  content_id  :integer
#  title       :string(255)
#  body        :text
#  locale      :string(255)
#  user_edited :boolean
#  created_at  :datetime
#  updated_at  :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

# Used to test muck_content_translation
class ContentTranslationTest < ActiveSupport::TestCase

  context "A content translation instance" do    
    setup do
      @content_translation = Factory(:content_translation)
    end    
    subject { @content_translation }
    should_belong_to :content
    should_scope_recent
  end
  
  context "named scope" do
    
    setup do
      @content = Factory(:content)
      ContentTranslation.destroy_all
      @first = Factory(:content_translation, :created_at => 1.day.ago, :content => @content, :title => 'a')
      @second = Factory(:content_translation, :created_at => 1.week.ago, :content => @content, :title => 'b')
    end
    
    # We have to build a custom 'by_newest' and 'by_alpha' test here since creating a content object 
    # will create a large number of content translations.
    context "by_newest scope" do
      should "sort by created_at" do
        assert_equal @first, ContentTranslation.by_newest[0]
        assert_equal @second, ContentTranslation.by_newest[1]
      end
    end
    
    context "by_alpha" do
      should "sort by title" do
        assert_equal @first, ContentTranslation.by_alpha[0]
        assert_equal @second, ContentTranslation.by_alpha[1]
      end
    end
    
    context "find by locale" do
      #named_scope :by_locale, lambda { |locale| { :conditions => ['content_translations.locale = ?', locale] } }
      setup do
        ContentTranslation.destroy_all
        @content_one = Factory(:content)
        @content_two = Factory(:content)
      end
      should "find two English translations" do
        translations = ContentTranslation.by_locale('en')
        assert_equal 2, translations.length
      end
      should "find two Spanish translations" do
        translations = ContentTranslation.by_locale('es')
        assert_equal 2, translations.length
      end
      should "delete translations" do
        assert_difference "ContentTranslation.count", -(@content_two.content_translations.count) do
          @content_two.destroy
        end
      end
    end
    
  end
  
end
