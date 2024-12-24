# frozen_string_literal: true

class UserSerializer < Blueprinter::Base
  fields  :id,
          :email,
          :last_active_at
end
