# frozen_string_literal: true

module Core
  module Concerns
    module ExceptionFilter
      extend ActiveSupport::Concern

      included do
        rescue_from StandardError, with: :render_default_exception
        rescue_from Core::Errors::BaseError, with: :render_core_exception
        rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found
        rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_params
      end

      private

      def render_core_exception(exception)
        render json: ExceptionSerializer.render(exception), status: exception.status
      end

      def render_invalid_params(exception)
        error = "Core::Errors::#{exception.record.class.name}Error".constantize.new(:invalid_params, detail: exception.record.errors.details)
        render json: ExceptionSerializer.render(error), status: error.status
      end

      def render_record_not_found(exception)
        error = "Core::Errors::#{exception.model}Error".constantize.new(:not_found)

        render json: ExceptionSerializer.render(error), status: error.status
      end

      def render_invalid_transition(exception)
        error = "Core::Errors::#{exception.object.class.name}Error".constantize.new(:invalid_transition, detail: exception.message)

        render json: ExceptionSerializer.render(error), status: error.status
      end

      def render_default_exception(exception)
        # TODO: enable this one if we have sentry
        # if Rails.env.local?
        #   p exception
        # else
        #   Sentry.capture_exception(exception)
        # end

        p exception

        render json: ExceptionSerializer.render(Core::Errors::BaseError.new), status: :internal_server_error
      end
    end
  end
end
