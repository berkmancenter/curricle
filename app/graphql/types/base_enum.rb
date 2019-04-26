module Types
  class BaseEnum < GraphQL::Schema::Enum
    def self.format_as_constant(str)
      str.gsub(%r{[\s\-\/\.]}, '_').gsub(/[^a-zA-Z0-9\_]/, '').upcase
    end

    def self.generate_enum_values(attr)
      strs = Course.distinct.pluck(attr).compact.sort
      strs.delete('')

      strs.each { |str| value(format_as_constant(str), str, value: str) }
    end
  end
end
