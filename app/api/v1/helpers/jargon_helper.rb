module API
  module V1
    module Helpers
      module JargonHelper
        def localization_service
          @localization_service ||= ::LocalizationService.new(current_user!, params[:id])
        end
      end
    end
  end
end
