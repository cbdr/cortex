class GetWebpages
  include Interactor

  SEARCH_PARAMS = %w(q).freeze

  def call
    webpages = ::Webpage

    if has_search_params?
      webpages = webpages.search_with_params(context.params, context.tenant)
    else
      webpages = webpages.show_all(context.tenant)
    end

    webpages = webpages.page(context.params.page).per(context.params.per_page)
    context.webpages = webpages.records
  end

  private

  def has_search_params?
    (context.params.to_h.keys & SEARCH_PARAMS).any?
  end
end
