# frozen_string_literal: true

require_relative 'curricle_importer'

class CurricleDivisionMappingImporter < CurricleImporter
  TABLE_NAME = 'division_mappings'

  SQL_COLUMNS = %w[
    academic_group
    subject_description
    division
    division_description
    created_at
    updated_at
  ].freeze

  def format_row(row)
    row.fields + [Time.current, Time.current]
  end
end

CurricleDivisionMappingImporter.new.run
