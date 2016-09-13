module Cortex
  module FieldTypes
    module Core
      module Tree
        class CheckboxCell < FieldCell
          def checkbox
            render
          end

          private

          def value
            if @model[:data].blank?
              false
            else
              @model[:data]["values"].include?(@model[:node]['id'].to_s) ? true : false
            end
          end

          def child_identifier
            @model[:child].to_s + " " + "->"
          end

          def display_lineage
            @model[:child].to_s + " " + @model[:node]["node"]["name"]
          end
        end
      end
    end
  end
end
