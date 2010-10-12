class Muck::ContentsController < ApplicationController
  include MuckContents::Models::MuckContentHandler
  
  uses_tiny_mce(:options => MuckContents.configuration.advanced_mce_options,
                :raw_options => MuckContents.configuration.raw_mce_options, 
                :only => [:new, :create, :edit, :update])

  before_filter :login_required, :only => [:create, :edit, :update, :destroy]
  before_filter :setup_parent, :only => [:new, :create]
  before_filter :get_secure_content, :only => [:edit, :update, :destroy]
  before_filter :setup_layouts, :only => [:new, :create, :edit, :update]
  
  def show
    handle_content_request
  end

  # If a content object is not found this method will render a 404 for users that are not allowed to add content.
  # If the user is allowed to add content a redirect to new is performed so that the content can be added.
  #
  # Notes:
  # Override 'new' by setting up @content and passing in a custom message via @new_content_message
  # For example:
  #    def new
  #      @content = Content.new(:custom_scope => 'my-stuff')
  #      @new_content_message = 'Add Content to My Stuff'
  #      super
  #    end
  #
  # It is also simple to override the new template.  Simply create a template in app/views/contents/new.html.erb 
  # and add something similar to the following:
  #    <div id="add_content">
  #      <%= output_errors(t('muck.contents.problem_adding_content'), {:class => 'help-box'}, @content) %>
  #      <%= content_form(@content) do |f| -%>
  #        <%# Add custom fields here.  ie %>
  #        <%= f.text_field :custom_thing %>
  #      <% end -%>
  #    </div>
  #
  # If you are overriding this method in a different controller (ie not contents_controller.rb) you can set
  # the template to render in a different location. For example, if you have a controller named blogs_controller.rb
  # that inherits Muck::ContentsController you can do this to render the new template in the /view/blogs/new.html.erb:
  # @new_template = 'blogs/new'
  #
  def new
    @content ||= Content.new
    @content.uri = params[:path] if params[:path]
    if logged_in? && has_permission_to_add_content(current_user, @parent, @content)
      flash[:notice] = @new_content_message || t('muck.contents.page_doesnt_exist_create')
      respond_to do |format|
        format.html { render :template => @new_template || 'contents/new'}
        format.pjs { render :template => @new_template || 'contents/new', :layout => 'popup'}
      end
    else
      # TODO think about caching this:
      @content = Content.find('404-page-not-found', :scope => MuckContents::GLOBAL_SCOPE) rescue nil
      if @content.blank?
        @content = Content.new(:title => I18n.t('muck.contents.default_404_title'), :body_raw => I18n.t('muck.contents.default_404_body'), :locale => I18n.locale.to_s)
        @content.uri = '/404-page-not-found'
        @content.save!
      end
      @title = @content.locale_title(I18n.locale)
      respond_to do |format| 
        format.html { render :template => "contents/show", :status => 404 }
        format.all  { render :nothing => true, :status => 404 } 
      end
    end
  end
  
  def create
    @content = Content.new(params[:content])
    @content.contentable = @parent if @parent
    @content.creator = current_user
    @content.current_editor = current_user
    @content.locale ||= I18n.locale
    return permission_denied unless has_permission_to_add_content(current_user, @parent, @content)
    
    @content.save!
    respond_to do |format|
      format.html do
        after_create_redirect
      end
      format.json do
        after_create_json
      end
    end
  rescue ActiveRecord::RecordInvalid => ex
    if @content
      @errors = @content.errors.full_messages.to_sentence
    else
      @errors = ex
    end
    message = t('muck.contents.create_error', :errors => @errors)
    respond_to do |format|
      format.html do
        flash[:error] = message
        render :template => 'contents/new'
      end
      format.json { render :json => { :success => false, :message => message, :errors => @errors } }
    end
  end

  # If you are overriding this method in a different controller (ie not contents_controller.rb) you can set
  # the template to render in a different location. For example, if you have a controller named blogs_controller.rb
  # that inherits Muck::ContentsController you can do this to render the new template in the /view/blogs/edit.html.erb:
  # @new_template = 'blogs/edit'
  #
  def edit
    @page_title = @content.locale_title(I18n.locale)
    @content.setup_uri_path # be sure to recover uri_path or scope will get messed up when the content is saved.
    respond_to do |format|
      format.html { render :template => @edit_template || 'contents/edit'}
      format.pjs { render :template => @edit_template || 'contents/edit', :layout => 'popup'}
    end
  end
  
  def update
    @content.current_editor = current_user
    @content.update_attributes!(params[:content])
    respond_to do |format|
      format.html do
        after_update_redirect
      end
      format.json { render :json => { :success => true, :content => @content, :parent_id => @parent ? @parent.id : nil, :type => 'update' } }
    end
  rescue ActiveRecord::RecordInvalid => ex
    @errors = @content.errors.full_messages.to_sentence
    message = t('muck.contents.update_error', :errors => @errors)
    respond_to do |format|
      format.html do
        flash[:error] = message
        render :template => 'contents/edit'
      end
      format.json { render :json => { :success => false, :message => message, :errors => @errors } }
    end
  end
  
  def destroy
    @content.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = t('muck.contents.content_removed')
        after_destroy_redirect
      end
      format.js do
        render(:update) do |page|
          page << "jQuery('##{@content.dom_id}').fadeOut();"
        end
      end
      format.json { render :json => { :success => true, :message => t("muck.contents.content_removed"), :content_id => @content.id } }
    end
  end  

  protected
    
    def after_create_redirect
      redirect_to @content.uri
    end
    
    def after_create_json
      # HACK there should be a way to force polymorphic_url to use an id instead of to_param
      update_path = polymorphic_url([@parent, @content]).gsub(@content.to_param, "#{@content.id}") # force the id.  The slugs can cause problems during edit
      render :json => { :success => true, :content => @content, :parent_id => @parent ? @parent.id : nil, :update_path => update_path, :preview_path => @content.uri, :type => 'create' }
    end
    
    def after_update_redirect
      redirect_to @content.uri
    end
    
    def after_destroy_redirect
      redirect_back_or_default(current_user)
    end
    
    # Setups up the layouts that are available in the 'layouts' pulldown.
    # Override this method to change the available layouts. Note that the
    # layout will need to exist in your 'views/layouts' directory
    def setup_layouts
      @content_layouts = []
      get_layouts(File.join(::Rails.root.to_s, 'app', 'views', 'layouts')).each do |layout|
        @content_layouts << OpenStruct.new(:name => layout.titleize, :value => layout)
      end
    end
    
    def get_layouts(path)
      layouts = []
      Dir.glob("#{path}/*").each do |layout_file|
        if File.directory?(layout_file)
          layouts << get_layouts(layout_file)
        else
          if layout_file.include?('.html.erb') || layout_file.include?('.html.haml')
            trimmed_layout_file = File.basename(File.basename(layout_file, '.*'), '.*') # get ride of html.erb, html.haml
            if trimmed_layout_file.first != '_'&& # don't include partials
              layouts << trimmed_layout_file
            end
          end
        end
      end
      layouts.flatten
    end

    # This method checks to see if the specified user has the right o
    # add content.  Override this method in an individual controller
    # to provide more restrictive or more liberal permissions.
    # Parameters:
    # user    - The user attempting to add content.
    # parent  - The parent object of the content.  May be nil.
    # content - The content to be added.  In an overridden method may want to check scope on the content
    #           to be sure a user doesn't attempt to change the scope to something they shouldn't have
    #           permission to.
    def has_permission_to_add_content(user, parent, content)
      return true if user.can_add_root_content?
      return false if parent.blank?
      parent.can_add_content?(user)
    end
    
    # Pass the numeric id to this method to ensure that the operations update and delete occur on the correct object
    def get_secure_content
      @content = Content.find(params[:id])
      if !@content.can_edit?(current_user)
        respond_to do |format|
          format.html do
            flash[:notice] = I18n.t('muck.contents.cant_delete_content')
            redirect_back_or_default current_user
          end
          format.js { render(:update){|page| page.alert I18n.t('muck.contents.cant_delete_content')}}
        end
      end
    end
    
    def setup_parent
      @parent = get_parent
    end
end
