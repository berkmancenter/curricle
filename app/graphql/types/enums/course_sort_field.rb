module Types
  module Enums
    class CourseSortField < Types::BaseEnum
      value('COURSE_ID', 'Course ID', value: %i[subject catalog_number])
      value('DEPARTMENT', 'Department', value: %i[subject])
      value('RELEVANCE', 'Relevance', value: %i[score academic_year term_name])
      value('SCHOOL', 'School', value: %i[academic_group])
      value('SEMESTER', 'Semester', value: %i[academic_year term_name])
      value('TITLE', 'Title', value: %i[title_sortable])
    end
  end
end
