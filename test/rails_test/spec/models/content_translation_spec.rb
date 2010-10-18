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

require File.dirname(__FILE__) + '/../spec_helper'

# Used to test muck_content_translation
describe ContentTranslation do

  describe "A content translation instance" do    
    before do
      @content_translation = Factory(:content_translation)
    end
    it { should belong_to :content }
    it { should scope_newer_than }
  end
  
  describe "named scope" do
    
    before do
      @content = Factory(:content)
      ContentTranslation.destroy_all
      @first = Factory(:content_translation, :created_at => 1.day.ago, :content => @content, :title => 'a')
      @second = Factory(:content_translation, :created_at => 1.week.ago, :content => @content, :title => 'b')
    end
    
    # We have to build a custom 'by_newest' and 'by_alpha' test here since creating a content object 
    # will create a large number of content translations.
    describe "by_newest scope" do
      it "should sort by created_at" do
        ContentTranslation.by_newest[0].should == @first
        ContentTranslation.by_newest[1].should == @second
      end
    end
    
    describe "by_alpha" do
      it "should sort by title" do
        ContentTranslation.by_alpha[0].should == @first
        ContentTranslation.by_alpha[1].should == @second
      end
    end
    
    describe "find by locale" do
      before do
        ContentTranslation.destroy_all
        @content_one = Factory(:content)
        @content_two = Factory(:content)
      end
      it "should find two English translations" do
        translations = ContentTranslation.by_locale('en')
        translations.length.should == 2
      end
      it "should find two Spanish translations" do
        translations = ContentTranslation.by_locale('es')
        translations.length.should == 2
      end
      it "should delete translations" do
        lambda{
          @content_two.destroy
        }.should change(ContentTranslation, :count).by(-@content_two.content_translations.count)
      end
    end
    
  end
  
end
