# frozen_string_literal: true

class MetaSerializer < BaseSerializer
  field :count, name: :total_items

  field :page, name: :current_page

  field :items, name: :per_page # TODO: change to limit if upgrade to Ruby 3+ and latest version of pagy

  field :pages, name: :total_pages
end
