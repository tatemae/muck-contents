module MuckContentsHelper
  
  # share is an optional share object that can be used to pre populate the form.
  # content:  Optional content object to be edited.
  # options:  html options for form.  For example:
  #             :html => {:id => 'a form'}
  def content_form(content = nil, options = {}, &block)
    content ||= Content.new
    options[:html] = {} if options[:html].nil?
    raw_block_to_partial('contents/form', options.merge(:content => content), &block)
  end
  
  # content uses friendly_id but we want the param in the form to use the number id
  def get_content_form_url(parent, content)
    if content.new_record?
      polymorphic_url([parent, content])
    else
      # HACK there should be a way to force polymorphic_url to use an id instead of to_param
      polymorphic_url([@parent, @content]).gsub(@content.to_param, "#{@content.id}") # force the id.  The slugs can cause problems during edit
    end
  end
  
  def show_preview(content)
    if content.new_record?
      %Q{<a style="display:none;" target="blank" id="preview" href="#">#{t('muck.contents.preview')}</a>}
    else
      %Q{<a id="preview" target="blank" href="#{content.uri}">#{t('muck.contents.preview')}</a>}
    end
  end
  
end