# frozen_string_literal: true

CurricleSchema = GraphQL::Schema.define do
  use BatchLoader::GraphQL

  mutation(Types::MutationType)
  query(Types::QueryType)
end
