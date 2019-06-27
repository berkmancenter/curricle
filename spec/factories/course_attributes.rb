FactoryBot.define do
  factory :course_attribute do
    course
    external_course_id { 1 }
    course_offer_number { 1 }
    term_code { 2112 }
    term_description { '2011 Spring' }
    session_code { 1 }
    class_section { 1 }
    crse_attribute { 'BTI' }
    crse_attribute_description { 'HDS: BTI Catalog Category' }
    crse_attr_value { 'N' }
    crse_attr_value_description { 'No BTI Category' }
    academic_career { 'HDS' }
    bracketed_flag { 'N' }
  end
end
