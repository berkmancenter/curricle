# frozen_string_literal: true

# Connection class for working with Sunspot search results via GraphQL
# Note: cursor-based pagination is not working with Sunspot 2.2.7
class SearchConnection < GraphQL::Relay::BaseConnection
  delegate :facet, :total, to: :nodes

  def cursor_from_node(_obj)
    '*'
  end

  def has_next_page # rubocop:disable Naming/PredicateName
    !nodes.results.last_page?
  end

  def has_previous_page # rubocop:disable Naming/PredicateName
    !nodes.results.first_page?
  end

  def paged_nodes
    nodes.results
  end
end

GraphQL::Relay::BaseConnection.register_connection_implementation(Sunspot::Search::StandardSearch, SearchConnection)

Connections::CoursesConnection = Types::CourseType.define_connection do
  name 'CoursesConnection'

  field :academic_groups do
    type types[Types::FacetType]

    resolve ->(search, _args, _ctx) { search.facet(:academic_group).rows }
  end

  field :components do
    type types[Types::FacetType]

    resolve ->(search, _args, _ctx) { search.facet(:component).rows }
  end

  field :departments do
    type types[Types::FacetType]

    resolve ->(search, _args, _ctx) { search.facet(:class_academic_org_description).rows }
  end

  field :subjects do
    type types[Types::FacetType]

    resolve ->(search, _args, _ctx) { search.facet(:subject).rows }
  end

  field :totalCount do
    type types.Int

    resolve ->(search, _args, _ctx) { search.total }
  end
end
