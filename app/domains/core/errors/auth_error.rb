# frozen_string_literal: true

module Core
  module Errors
    class AuthError < BaseError
      # rubocop:disable Style/ClassVars
      @@errors = {
        unauthenticated: {
          status: 401,
          code: 20_000,
          message: 'Unauthenticated'
        },
        unauthorized: {
          status: 401,
          code: 20_001,
          message: 'Unauthorized'
        },
        already_verified: {
          status: 403,
          code: 20_002,
          message: 'Already verified'
        },
        otp_expired: {
          status: 403,
          code: 20_003,
          message: 'OTP expired'
        },
        missing_password: {
          status: 422,
          code: 20_004,
          message: 'Missing Password'
        }
      }.freeze
      # rubocop:enable Style/ClassVars

      def initialize(type = nil, detail: nil)
        super(**(@@errors[type] || {}).merge(detail: detail))
      end
    end
  end
end
