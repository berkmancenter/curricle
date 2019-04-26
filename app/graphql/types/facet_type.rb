# frozen_string_literal: true

module Types
  class FacetType < Types::BaseObject
    description 'Represents a Solr facet'

    field :count, Integer, null: true
    field :value, String, null: true
  end
end
