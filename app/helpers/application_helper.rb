module ApplicationHelper
  def title
    title = 'Cortex Administration'
    title += " | #{render_breadcrumbs builder: TitleBuilder}" if render_breadcrumbs
    title
  end

  def extra_config
    Cortex.config.extra
  end

  def user_session_props
    {
      environment: environment,
      active_tenant: current_user.active_tenant,
      current_user: current_user,
      tenants: current_user.tenants_with_children,
      csrf_token: form_authenticity_token,
      sidebarExpanded: (current_page? root_path),
      environment_abbreviated: environment_abbreviated
    }
  end

  def wizard_props
    if @wizard
      @wizard.data.merge({
        content_type: @content_type,
        content_item: @content_item,
        fields: @content_type.fields
      })
    else
      {}
    end
  end

  def index_props
    @index || {}
  end

  def content_type_objects
    @content_type_objects ||= ContentType.includes(:fields, :decorators).all.each_with_object({}) do |ct, hsh|
      hsh[ct.id] = { contentType: ct, fields: ct.fields, decorators: ct.decorators  }
    end
  end

  def content_type_builder_props
    if params[:id]
      @ct = ContentType.includes(:fields, :decorators).find(params[:id])
    {
      content_type: { contentType: @ct, fields: @ct.fields, fieldsLookup: @ct.fields.each_with_object({}) { |field, lookup| lookup[field.id] = field }, decorators: @ct.decorators },
      wizard: @ct.decorators.find_by_name('Wizard'),
      index: @ct.decorators.find_by_name('Index'),
      rss: @ct.decorators.find_by_name('Rss'),
    }
    else
      {
        content_type: { contentType: ContentType.new(creator_id: current_user.id, tenant_id: current_user.active_tenant.id, contract_id: Contract.first.id ), fields: [], fieldsLookup: {}, decorators: [] },
        wizard: Decorator.new(name: 'Wizard', data: {steps: []}),
        index: Decorator.new(name: 'Index', data: {columns: []}),
        rss: Decorator.new(name: 'Rss', data: {channel: {}, item: {}}),
      }
    end
  end

  def cortex_props
    user_session_props.merge({
      wizard: wizard_props,
      index: index_props,
      content_types: content_type_objects,
      creator: content_type_builder_props
    })
  end

  def qualtrics_domain
    extra_config.qualtrics_id.delete('_').downcase
  end

  def flag_enabled?(flag_name)
    Cortex.flipper[flag_name].enabled?(current_user, request)
  end

  def environment
    request.local? ? :local : Rails.env
  end

  def environment_abbreviated
    case environment
      when 'production'
        :prd
      when 'staging'
        :stg
      when 'development'
        :dev
      else
        :loc
    end
  end
end
