# frozen_string_literal: true

class ExceptionSerializer < BaseSerializer
  fields :code,
          :status,
          :message

  field :detail, if: ->(_field_name, exception, _options) { exception.detail.present? }
end
