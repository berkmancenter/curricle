# frozen_string_literal: true

class CurricleSchema < GraphQL::Schema
  use BatchLoader::GraphQL

  mutation(Types::Mutation)
  query(Types::Query)
end
