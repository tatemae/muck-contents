class Admin::Muck::ContentsController < Admin::Muck::BaseController
  
  def index
    respond_to do |format|
      format.html do
        @contents = Content.by_title.by_newest.paginate(:page => @page, :per_page => @per_page)
        render :template => 'admin/contents/index' 
      end
      format.json do
        @contents = Content.by_title.by_newest.where("title like ?", params[:term] + '%').paginate(:page => @page, :per_page => @per_page)
        render :json => @contents
      end
    end
  end
  
  def destroy
    @content = Content.find(params[:id])
    @content.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = t('muck.contents.content_removed')
        redirect_to admin_contents_path
      end
      format.js do
        render(:update) do |page|
          page << "jQuery('##{@content.dom_id}').fadeOut();"
        end
      end
      format.json { render :json => { :success => true, :message => t("muck.contents.content_removed"), :content_id => @content.id } }
    end
  end
  
end
