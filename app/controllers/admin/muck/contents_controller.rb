class Admin::Muck::ContentsController < Admin::Muck::BaseController
  
  def index
    @contents = Content.by_title.by_newest
    respond_to do |format|
      format.html { render :template => 'admin/contents/index' }
    end
  end
  
end
