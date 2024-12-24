# app/controllers/auth_controller.rb
module Api
  module V1
    class AuthController < BaseController
      def login
        user = User.find_by(email: params[:email])

        if user&.valid_password?(params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          render json: { token: token }, status: :ok
        else
          raise Core::Errors::AuthError, :unauthenticated
        end
      end
    end
  end
end
