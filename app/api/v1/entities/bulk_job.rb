module API
  module V1
    module Entities
      class BulkJob < Grape::Entity
        expose :id, documentation: { type: 'UUID', desc: 'Bulk upload job UUID', required: true }
        expose :content_type, documentation: { type: 'String', desc: 'Type of content being processed. Types supported: Media (/media/bulk_job)' }
        expose :status, documentation: { type: 'String', desc: 'Bulk upload job status' }
        expose :log, documentation: { type: 'Text', desc: 'Bulk upload job full log' }
        expose :created_at, documentation: { type: 'dateTime', desc: 'Created date'}
        expose :updated_at, documentation: { type: 'dateTime', desc: 'Updated date'}
        expose :user, with: 'Entities::User', as: :creator, documentation: { type: 'User', desc: 'Owner' }
        expose :metadata, documentation: { type: 'String', desc: 'Bulk Media metadata (CSV) URL', required: true }
        expose :assets, documentation: { type: 'String', desc: 'Assets to be uploaded (ZIP) URL' }, if: lambda { |bulkJob, _| bulkJob.assets_file_name.present? }
      end
    end
  end
end
