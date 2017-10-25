module V1
  module Entities
    class User < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "User ID" }
      expose :fullname, documentation: { type: "String", desc: "User's full name" }
      with_options if: { full: true } do
        expose :email, documentation: { type: "String", desc: "User Email" }
        expose :admin, documentation: { type: "Boolean", desc: "Is User Admin?" }
        expose :created_at, documentation: { type: 'dateTime', desc: "Created Date" }
        expose :updated_at, documentation: { type: 'dateTime', desc: "Updated Date" }
        expose :sign_in_count, documentation: { type: "Integer", desc: "Sign in Count" }
        expose :firstname, documentation: { type: "String", desc: "User First Name" }
        expose :lastname, documentation: { type: "String", desc: "User Last Name" }
        expose :gravatar, documentation: { type: "String", desc: "Gravatar URL" }
        expose :tenant_id, documentation: { type: "Integer", desc: "User Tenant ID" } # Retained for backwards comparability. TODO: Remove.
        expose :tenant, with: '::V1::Entities::Tenant', documentation: { type: "Tenant", desc: "User Tenant" }
      end
    end
  end
end