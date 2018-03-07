# frozen_string_literal: true

Types::FacetType = GraphQL::ObjectType.define do
  name 'Facet'
  description 'Represents a Solr facet'

  field :value, types.String
  field :count, types.Int
end
