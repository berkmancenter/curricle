# frozen_string_literal: true

Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  field :setAnnotation, function: Mutations::SetAnnotation.new
end
