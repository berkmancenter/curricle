# frozen_string_literal: true

module Types
  # Connection class for working with Sunspot search results via GraphQL
  class CoursesConnectionType < Types::BaseConnection
    edge_type(Types::CourseEdgeType)

    field :academic_groups, [Types::FacetType], null: false
    field :components, [Types::FacetType], null: false
    field :departments, [Types::FacetType], null: false
    field :subjects, [Types::FacetType], null: false
    field :total_count, Integer, null: false

    def academic_groups
      object.facet(:academic_group).rows
    end

    def components
      object.facet(:component).rows
    end

    def departments
      object.facet(:subject_academic_org_description).rows
    end

    def subjects
      object.facet(:subject).rows
    end

    def total_count
      object.total
    end
  end
end

GraphQL::Relay::BaseConnection.register_connection_implementation(
  Sunspot::Search::StandardSearch,
  Connections::SunspotStandardSearch
)
