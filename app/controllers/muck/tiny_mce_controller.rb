class Muck::TinyMceController < ApplicationController
  
  layout 'tiny_mce'
  
  before_filter :get_parent
  
  def tiny_mce_files
    @body_tag = 'advfile'
    @load_files_path = files_for_content_url(make_parent_params(@parent).merge(:format => 'json'))
    respond_to do |format|
      format.html { render :template => 'tiny_mce/files'}
    end
  end
  
  def tiny_mce_images
    @body_tag = 'advimage'
    @load_files_path = images_for_content_url(make_parent_params(@parent).merge(:format => 'json'))
    respond_to do |format|
      format.html { render :template => 'tiny_mce/images'}
    end
  end
  
  def tiny_mce_links
    @body_tag = 'advlink'
    @load_files_path = files_for_content_url(make_parent_params(@parent).merge(:format => 'json'))
    respond_to do |format|
      format.html { render :template => 'tiny_mce/links'}
    end
  end
  
  def images_for_content
    @parent = current_user if @parent.blank?
    @images = @parent.uploads.images.paginate(:page => @page, :per_page => @per_page, :order => 'created_at desc')
    respond_to do |format|
      format.json { render :json => @images.to_json(json_options) }
    end
  end
  
  def files_for_content
    @parent = current_user if @parent.blank?
    @files = @parent.uploads.files.paginate(:page => @page, :per_page => @per_page, :order => 'created_at desc')
    respond_to do |format|
      format.json { render :json => @files.to_json(json_options) }
    end
  end

  protected
    def json_options
      { :only => [:id], :methods => [:icon, :thumb, :file_name] }
    end
  
end