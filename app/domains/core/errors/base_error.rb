# frozen_string_literal: true

module Core
  module Errors
    class BaseError < StandardError
      attr_reader :code, :status, :detail

      def initialize(message: 'Something went wrong', code: 10_000, status: 500, detail: nil)
        super(message)

        @code = code
        @status = status
        @detail = detail
      end

      def to_json(*_args)
        result = {
          code: @code,
          status: @status,
          message: message
        }

        return result unless @detail

        result.merge(detail: @detail)
      end
    end
  end
end
