# frozen_string_literal: true

class BaseSerializer < Blueprinter::Base
  class << self
    def active_storage_field(field_name, view: nil, array: false, blueprint: ActiveStorageSerializer, &block)
      field(field_name) do |object|
        data = block.present? ? yield(object) : object.send(field_name)

        if array
          data.map do |datumn|
            blueprint.render_as_hash(datumn, view: view)
          end
        elsif data.present?
          blueprint.render_as_hash(data, view: view)
        end
      end
    end

    def decorate_fields(*field_names)
      field_names.each do |field_name|
        field(field_name, {}) do |object|
          object.decorate.send(field_name)
        end
      end
    end

    def sensitive_field(field_name, opts = {})
      field(field_name, opts) do |object, options|
        data = object.send(field_name)
        current_user = options[:current_user]

        if current_user.present?
          data
        else
          data.gsub(/.(?=.{4})/, '*')
        end
      end
    end
  end
end
