require_relative '../helpers/resource_helper'

module API
  module V1
    module Resources
      class Locales < Grape::API
        helpers Helpers::SharedParams

        doorkeeper_for :index, :show, scopes: [:'view:locales']
        doorkeeper_for :destroy, :create, :update, scopes: [:'modify:locales']

        resource :localizations do
          segment '/:id' do
            resource :locales do
              helpers Helpers::PaginationHelper
              helpers Helpers::LocaleHelper
              helpers Helpers::LocalizationHelper

              desc 'Show all locales', {entity: Entities::Locale, nickname: 'showAllLocales'}
              get do
                authorize! :view, ::Locale

                @locales = localization.locales.order(created_at: :desc).page(page).per(per_page)

                set_pagination_headers(@locales, 'locales')
                present @locales, with: Entities::Locale
              end

              desc 'Get locale', {entity: Entities::Locale, nickname: 'showLocale'}
              get ':locale_name' do
                authorize! :view, locale!

                @locale = Locale.find_by_name!(params[:locale_name])

                present @locale, with: Entities::Locale
              end

              desc 'Delete locale', {nickname: 'deleteLocale'}
              delete ':locale_name' do
                authorize! :delete, locale!

                locale.destroy!
              end

              desc 'Create a locale', {entity: Entities::Locale, params: Entities::Locale.documentation, nickname: 'createLocale'}
              post do
                authorize! :create, ::Locale

                allowed_params = remove_params(Entities::Locale.documentation.keys, :id, :created_at, :updated_at, :available_locales, :locales, :creator)

                @locale = localization.locales.new(declared(params, {include_missing: false}, allowed_params))
                @locale.user = current_user!
                localization.save!

                present @locale, with: Entities::Locale
              end

              desc 'Update a locale', {entity: Entities::Locale, params: Entities::Locale.documentation, nickname: 'updateLocale'}
              put do
                authorize! :update, locale!

                allowed_params = remove_params(Entities::Locale.documentation.keys, :id, :created_at, :updated_at, :available_locales, :locales, :creator)

                locale.update!(declared(params, {include_missing: false}, allowed_params))

                present locale, with: Entities::Locale
              end
            end
          end
        end
      end
    end
  end
end
