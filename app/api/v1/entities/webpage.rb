module V1
  module Entities
    class Webpage < Grape::Entity
      expose :id, documentation: { type: 'Integer', desc: 'Webpage ID', required: true }
      expose :name, documentation: { type: 'String', desc: 'Webpage Name', required: true }
      expose :created_at, documentation: { type: 'dateTime', desc: 'Created Date'}
      expose :updated_at, documentation: { type: 'dateTime', desc: 'Updated Date'}
      expose :snippets, with: '::V1::Entities::Snippet', documentation: {type: 'Snippet', is_array: true, desc: 'All associated Snippets for this Webpage'}

      expose :seo_title, documentation: { type: 'String', desc: "SEO Meta Tag Title" }
      expose :seo_description, documentation: { type: 'String', desc: "SEO Meta Tag Description" }
      expose :seo_keyword_list, documentation: {type: "String", is_array: true, desc: "SEO-specific keywords"}
      expose :noindex, documentation: { type: 'Boolean', desc: "SEO No Index Robots Setting" }
      expose :nofollow, documentation: { type: 'Boolean', desc: "SEO No Follow Robots Setting" }
      expose :noodp, documentation: { type: 'Boolean', desc: "SEO No ODP Setting" }
      expose :nosnippet, documentation: { type: 'Boolean', desc: "SEO No Snippet Robots Setting" }
      expose :noarchive, documentation: { type: 'Boolean', desc: "SEO No Archive Setting" }
      expose :noimageindex, documentation: { type: 'Boolean', desc: "SEO No Image Index Robots Setting" }

      expose :dynamic_yield_sku, documentation: { type: 'String', desc: "Dynamic Yield Webpage SKU/ID" }
      expose :dynamic_yield_category, documentation: { type: 'String', desc: "Dynamic Yield Webpage Category" }

      expose :tables_widget_json, documentation:  {type: 'Hash', is_array: true, desc: 'Tables Widget Data as JSON'}

      with_options if: { full: true } do
        expose :user, with: '::V1::Entities::User', documentation: {type: 'User', desc: 'Owner'}
        expose :url, documentation: { type: 'String', desc: 'URL of Webpage' }

        expose :tables_widget_yaml, documentation:  {type: 'Hash', is_array: true, desc: 'Tables Widget Data as YAML'}
      end
    end
  end
end
