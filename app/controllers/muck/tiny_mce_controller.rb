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
  
  def tiny_mce_flickr
    @body_tag = 'flickr'
    Fleakr.api_key = GlobalConfig.flickr_api_key
    @photos = Fleakr.search(params[:search]) unless params[:search].blank?
    respond_to do |format|
      format.html { render :template => 'tiny_mce/flickr'}
    end
  end
  
  def images_for_content
    @parent = current_user if @parent.blank?
    @images = @parent.uploads.images.paginate(:page => @page, :per_page => @per_page, :order => 'created_at desc')
    respond_to do |format|
      format.json { render :json => make_json(@images) }
    end
  end
  
  def files_for_content
    @parent = current_user if @parent.blank?
    @files = @parent.uploads.files.paginate(:page => @page, :per_page => @per_page, :order => 'created_at desc')
    respond_to do |format|
      format.json { render :json => make_json(@files) }
    end
  end

  def links_for_content
    @contents = Content.by_alpha
    respond_to do |format|
      format.json { render :json => autocomplete_urls_json(@contents) }
    end
  end
  
  protected
    def make_json(uploads)
      return [] if uploads.blank?
      uploads.collect {|f| f.as_json(json_options)}
    end
  
    def json_options
      { :only => [:id], :methods => [:icon, :thumb, :file_name] }
    end
    
    def autocomplete_urls_json(items)
      return '' if items.blank?
      ActiveRecord::Base.include_root_in_json = false
      json = items.collect{|item| item.as_json(:only => [:title], :methods => [:uri]) }
      ActiveRecord::Base.include_root_in_json = true
      json
    end
    
end