require_relative '../helpers/resource_helper'

module API
  module V1
    module Resources
      class Locales < Grape::API
        helpers Helpers::SharedParams

        resource :localizations do
          segment '/:id' do
            resource :locales do
              helpers Helpers::PaginationHelper
              helpers Helpers::JargonHelper
              helpers Helpers::LocaleHelper

              desc 'Show all locales', {entity: Entities::Locale, nickname: 'showAllLocales'}
              oauth2 'view:locales'
              get do
                authorize! :view, ::Locale

                @locales = Kaminari.paginate_array(localization_service.all_locales).page(page).per(per_page)

                set_pagination_headers(@locales, 'locales')
                present @locales, with: Entities::Locale
              end

              desc 'Get locale', {entity: Entities::Locale, nickname: 'showLocale'}
              oauth2 'view:locales'
              get ':locale_name' do
                authorize! :view, locale!

                @locale = localization_service.get_locale(params[:locale_name])

                present @locale, with: Entities::Locale
              end

              desc 'Delete locale', {nickname: 'deleteLocale'}
              oauth2 'modify:locales'
              delete ':locale_name' do
                authorize! :delete, locale!

                @locale = localization_service.delete_locale(params[:locale_name])

                present @locale, with: Entities::Locale
              end

              desc 'Create a locale', {entity: Entities::Locale, params: Entities::Locale.documentation, nickname: 'createLocale'}
              oauth2 'modify:locales'
              post do
                authorize! :create, ::Locale

                allowed_params = remove_params(Entities::Locale.documentation.keys, :id, :created_at, :updated_at, :available_locales, :locales, :creator)

                @locale = localization_service.create_locale(declared(params, {include_missing: false}, allowed_params))

                present @locale, with: Entities::Locale
              end

              desc 'Update a locale', {entity: Entities::Locale, params: Entities::Locale.documentation, nickname: 'updateLocale'}
              oauth2 'modify:locales'
              put ':locale_name' do
                authorize! :update, locale!

                allowed_params = remove_params(Entities::Locale.documentation.keys, :id, :created_at, :updated_at, :available_locales, :locales, :creator)

                @locale = localization_service.update_locale(params[:locale_name], declared(params, {include_missing: false}, allowed_params))

                present @locale, with: Entities::Locale
              end
            end
          end
        end
      end
    end
  end
end
