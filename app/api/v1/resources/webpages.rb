module V1
  module Resources
    class Webpages < Grape::API
      helpers ::V1::Helpers::ParamsHelper

      resource :webpages do
        include Grape::Kaminari
        include Grape::Extensions::Hashie::Mash::ParamBuilder
        helpers ::V1::Helpers::WebpagesHelper
        paginate per_page: 25, max_per_page: 1000

        desc 'Show all webpages', { entity: ::V1::Entities::Webpage, nickname: 'showAllWebpages' }
        params do
          optional :q, type: String
        end
        get do
          authorize! :view, ::Webpage
          require_scope! 'view:webpages'

          @webpages = ::GetWebpages.call(params: declared(clean_params(params), include_missing: false), tenant: current_tenant).webpages
          ::V1::Entities::Webpage.represent paginate(@webpages).records, full: true
        end

        desc 'Show Webpage Snippets as public feed by URL', { entity: ::V1::Entities::Webpage, nickname: 'showWebpageFeed' }
        params do
          requires :url, type: String
        end
        get 'feed' do
          require_scope! 'view:webpages'
          @webpage = ::GetWebpageFeed.call(params: declared(clean_params(params), include_missing: false), tenant: current_tenant).webpage
          not_found! unless @webpage
          authorize! :view, @webpage
          present @webpage, with: ::V1::Entities::Webpage
        end

        desc 'Get webpage', { entity: ::V1::Entities::Webpage, nickname: 'showWebpage' }
        get ':id' do
          require_scope! 'view:webpages'
          authorize! :view, webpage!

          present webpage, with: ::V1::Entities::Webpage, full: true
        end

        desc 'Create webpage', { entity: ::V1::Entities::Webpage, params: ::V1::Entities::Webpage.documentation, nickname: 'createWebpage' }
        post do
          require_scope! 'modify:webpages'
          authorize! :create, ::Webpage

          webpage_params = params[:webpage] || params

          @webpage = ::Webpage.new(declared(webpage_params, { include_missing: false }, ::V1::Entities::Webpage.documentation.keys))
          webpage.user = current_user!
          webpage.save!

          present webpage, with: ::V1::Entities::Webpage, full: true
        end

        desc 'Update webpage', { entity: ::V1::Entities::Webpage, params: ::V1::Entities::Webpage.documentation, nickname: 'updateWebpage' }
        put ':id' do
          require_scope! 'modify:webpages'
          authorize! :update, webpage!

          webpage_params = params[:webpage] || params
          allowed_params = remove_params(::V1::Entities::Webpage.documentation.keys, :user) + [:snippets_attributes]
          update_params = declared(webpage_params, { include_missing: false }, allowed_params)
          update_params[:snippets_attributes].each {|snippet|
            snippet.user = current_user!
            snippet[:document_attributes].user = current_user!
          }

          if params[:seo_keyword_list]
            webpage.seo_keyword_list = params[:seo_keyword_list]
          end
	  webpage.user = current_user!

          webpage.update!(update_params.to_hash)
          CacheBustWebpageJob.perform_now(webpage.url)

          present webpage, with: ::V1::Entities::Webpage, full: true
        end

        desc 'Delete webpage', { nickname: 'deleteWebpage' }
        delete ':id' do
          require_scope! 'modify:webpages'
          authorize! :delete, webpage!

          begin
            webpage.destroy
          rescue Cortex::Exceptions::ResourceConsumed => e
            error = error!({
                             error:   'Conflict',
                             message: e.message,
                             status:  409
                           }, 409)
            error
          end
        end
      end
    end
  end
end
