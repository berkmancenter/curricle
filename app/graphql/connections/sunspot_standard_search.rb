# frozen_string_literal: true

# Note: cursor-based pagination is not working with Sunspot 2.2.7
module Connections
  class SunspotStandardSearch < GraphQL::Relay::BaseConnection
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

    private

    def sliced_nodes
      nodes.results
    end

    def paged_nodes
      nodes.results
    end
  end
end
