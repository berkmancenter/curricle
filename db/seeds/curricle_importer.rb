# frozen_string_literal: true

require 'csv'

# Parent class with shared code inherited by the various seed files
class CurricleImporter
  COURSES_CACHE =
    Course
    .pluck(:id, :term_year, :term_name, :external_course_id, :class_section)
    .each_with_object({}) do |el, hash|
      key = el[1..-1].join
      value = el[0]

      hash[key] = value
    end

  def initialize
    @table_name = self.class::TABLE_NAME
    @sql_columns = self.class::SQL_COLUMNS
    @csv_file = Rails.root.join('lib', 'seeds', "#{@table_name}.csv")
    @progressbar = progressbar(@csv_file)
    @pgconn = Course.connection.raw_connection
    @enco = PG::TextEncoder::CopyRow.new
  end

  def run
    puts "Seeding #{@table_name}"

    @pgconn.copy_data("COPY #{@table_name} (#{@sql_columns.join(',')}) FROM STDIN", @enco) do
      CSV.foreach(@csv_file, headers: true, header_converters: :symbol) do |row|
        formatted_row = format_row(row)

        @pgconn.put_copy_data(formatted_row) if formatted_row.present?

        @progressbar.increment!
      end
    end
  end

  private

  def csv_lines(csv_file)
    `wc -l '#{csv_file}'`.to_i - 1
  end

  def progressbar(csv_file)
    max = csv_lines(csv_file)

    ProgressBar.new(max)
  end
end
