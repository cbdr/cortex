module SearchablePost
  extend ActiveSupport::Concern

  included do
    include Searchable

    mapping do
      indexes :id, :type => :integer, :index => :not_analyzed
      indexes :tenant_id, :type => :integer, :index => :not_analyzed
      indexes :title, :analyzer => :snowball
      indexes :body, :analyzer => :snowball
      indexes :draft, :type => :boolean
      indexes :short_description, :analyzer => :snowball
      indexes :copyright_owner, :analyzer => :keyword
      indexes :author, :analyzer => :keyword
      indexes :created_at, :type => :date, :include_in_all => false
      indexes :published_at, :type => :date, :include_in_all => false
      indexes :tag_list, :type => :string, :analyzer => :keyword
      indexes :categories, :analyzer => :keyword
      indexes :job_phase, :analyzer => :keyword
      indexes :type, :analyzer => :keyword
      indexes :industries, :analyzer => :keyword
      indexes :is_published, :type => :boolean
    end

    def as_indexed_json(options = {})
      json = as_json(only: [:id, :title, :body, :draft, :short_description, :copyright_owner,
                            :created_at, :published_at, :job_phase, :type])
      json[:categories] = categories.collect { |c| c.name }
      json[:industries] = industries.collect { |i| i.soc }
      json[:tags] = tag_list.to_a
      json[:author] = author ? author.fullname : custom_author
      json[:tenant_id] = user.tenant.id
      json[:is_published] = self.published?
      json
    end

    def related(tenant)
      bool = {bool: {should: [], filter: [{term: {tenant_id: tenant.id}}]}}

      SearchablePost.published_filter(bool[:bool][:filter], self)

      mlt = [{
               more_like_this: {
                 fields: %w(title short_description job_phase categories tags),
                 docs: [
                   {
                     _id: id
                   }
                 ],
                 min_doc_freq: 1,
                 min_term_freq: 1,
                 include: false
               }
             }
      ]

      bool[:bool][:should] << mlt
      ::Post.search query: bool
    end
  end

  module ClassMethods
    def search_with_params(params, tenant)
      q = params[:q]
      categories = params[:categories]
      job_phase = params[:job_phase]
      post_type = params[:post_type]
      industries = params[:industries]
      author = params[:author]

      bool = {bool: {must: [], filter: [{term: {tenant_id: tenant.id}}]}}

      if q
        bool[:bool][:must] << {multi_match: {fields: %w(title^2 _all), query: query_massage(q)}}
      end
      if categories
        bool[:bool][:filter] << self.terms_search(:categories, categories.split(','))
      end
      if job_phase
        bool[:bool][:filter] << self.terms_search(:job_phase, job_phase.split(','))
      end
      if post_type
        bool[:bool][:filter] << self.terms_search(:type, post_type.split(','))
      end
      if industries
        bool[:bool][:filter] << self.terms_search(:industries, industries.split(','))
      end
      if author
        bool[:bool][:filter] << self.term_search(:author, author)
      end
      SearchablePost.published_filter(bool[:bool][:filter], self)

      self.search query: bool
    end

    def show_all(tenant)
      bool = {bool: {filter: [{term: {tenant_id: tenant.id}}]}}

      search query: bool, sort: [{created_at: {order: 'desc'}}]
    end
  end

  def self.published_filter(filter, post)
    filter << post.term_search(:is_published, true)
  end
end
