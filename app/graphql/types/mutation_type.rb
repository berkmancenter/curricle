# frozen_string_literal: true

Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  field :addAnnotation, function: Mutations::AddAnnotation.new
end
