# frozen_string_literal: true

module Core
  module Concerns
    module BlueprinterRender
      extend ActiveSupport::Concern

      def render_resource(resource, opts = {})
        resource_serializer_class, is_array = serializer_class(resource, opts)

        if resource_serializer_class.nil?
          return render(
            json: {
              data: camelize_keys(resource)
            }
          )
        end

        serializer_opts = if is_array
                            {
                              each_serializer: resource_serializer_class
                            }
                          else
                            {
                              serializer: resource_serializer_class
                            }
                          end

        serializer_opts[:meta] = MetaSerializer.render_as_hash(opts[:meta]) if opts[:meta].present?

        render(
          json: resource_serializer_class.render(
            resource,
            opts.except(:each_serializer, :serializer, :meta)
            .merge(
              **serializer_opts,
              root: opts[:root].presence || :data
            )
          )
        )
      end

      private

      def camelize_keys(resource)
        return resource.map { |item| camelize_keys(item) } if resource.is_a?(Array)

        return resource unless resource.is_a?(Hash)

        resource.deep_transform_keys! { |key| key.to_s.camelize(:lower).to_sym }
      end

      def serializer_class(resource, opts)
        return [] if resource.nil?

        is_array = resource.is_a?(Array) || resource.is_a?(ActiveRecord::Relation)

        class_name = if is_array
                       opts[:each_serializer].presence || array_serializer_class(resource, opts)
                     else
                       opts[:serializer].presence || single_serializer_class(resource, opts)
                     end

        [class_name, is_array]
      rescue StandardError
        []
      end

      def single_serializer_class(resource, opts)
        "#{handle_namespace(resource.class.base_class, opts)}Serializer".constantize
      end

      def array_serializer_class(resource, opts)
        resource_class = if resource.respond_to?(:klass)
                           resource.klass.base_class
                         else
                           resource.first.class.base_class
                         end

        "#{handle_namespace(resource_class, opts)}Serializer".constantize
      end

      def handle_namespace(resource_class, opts)
        module_names = if opts[:module].present?
                         (opts[:module].is_a?(Array) ? opts[:module] : [opts[:module]]).map do |module_name|
                           module_name.to_s.camelcase
                         end
                       else
                         []
                       end.join('::')

        return if opts[:keep_namespace].present?

        if module_names.present?
          [module_names, resource_class].join('::')
        else
          resource_class.to_s.demodulize
        end
      end
    end
  end
end
