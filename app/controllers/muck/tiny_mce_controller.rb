class Muck::TinyMceController < ApplicationController
  
  def tiny_mce_files
    respond_to do |format|
      format.html { render :template => 'tiny_mce/files'}
    end
  end
  
  def tiny_mce_images
    respond_to do |format|
      format.html { render :template => 'tiny_mce/files'}
    end
  end
  
end