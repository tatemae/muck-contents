class Muck::TinyMceController < ApplicationController
  
  layout 'tiny_mce'
  
  before_filter :get_parent
  
  def tiny_mce_files
    @body_tag = 'advfile'
    respond_to do |format|
      format.html { render :template => 'tiny_mce/files'}
    end
  end
  
  def tiny_mce_images
    @body_tag = 'advimage'
    respond_to do |format|
      format.html { render :template => 'tiny_mce/files'}
    end
  end
  
  def tiny_mce_links
    @body_tag = 'advlink'
    respond_to do |format|
      format.html { render :template => 'tiny_mce/links'}
    end
  end
  
end