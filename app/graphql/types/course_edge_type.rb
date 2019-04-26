# frozen_string_literal: true

module Types
  # Define edge type used in courses connection
  class CourseEdgeType < GraphQL::Types::Relay::BaseEdge
    node_type(Types::CourseType)
  end
end
