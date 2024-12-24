# app/controllers/auth_controller.rb
module Api
  class BaseController < ApplicationController
    skip_before_action :verify_authenticity_token

    include Core::Concerns::ExceptionFilter
    include Core::Concerns::BlueprinterRender
  end
end
