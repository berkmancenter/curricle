# frozen_string_literal: true

class CoursesController < ApplicationController
  before_action :authenticate_user!
  #TODO Clean up after session and token implementation at frontend
  skip_before_action :verify_authenticity_token
  before_action :set_current_user

  # TODO: demo purpose
  def search
    search = Course.search do
      fulltext params[:keyword] ? params[:keyword] : '', fields: :title
      fulltext params[:keyword] ? params[:keyword] : '', fields: :course_description_long
      with :term_year, 2017
      paginate page: 1, per_page: 50
    end
    @courses = search.results
    render json: @courses, methods: %i[meeting instructor user_tags user_annotations user_schedule]
  end

  def index
    render json: Course.first(50).as_json
  end

  def categories
    filters = []
    filters << { name: 'Department', options: Course.departments, field: 'class_academic_org_description' }
    filters << { name: 'Semester', options: Course.semesters, field: 'term_name' }
    render json: filters.as_json
  end

  def courses_by_day
    term_name = params[:term_name] || current_semester.split(' ').first
    term_year = params[:term_year] || current_semester.split(' ').last
    courses = [
      {
        day: 'Monday',
        courses: Course.courses_by_day_and_term('meets_on_monday', term_name, term_year)
      },
      {
        day: 'Tuesday',
        courses: Course.courses_by_day_and_term('meets_on_tuesday', term_name, term_year)
      },
      {
        day: 'Wednesday',
        courses: Course.courses_by_day_and_term('meets_on_wednesday', term_name, term_year)
      },
      {
        day: 'Thursday',
        courses: Course.courses_by_day_and_term('meets_on_thursday', term_name, term_year)
      },
      {
        day: 'Friday',
        courses: Course.courses_by_day_and_term('meets_on_friday', term_name, term_year)
      }
    ]
    render json: courses
  end

  # TODO to create API which gives data on the basis of Year
  def courses_by_year
    term_name = params[:term_name] || current_semester.split(' ').first
    term_year = params[:term_year] || current_semester.split(' ').last
    courses = [
      {
        day: 'Fall 2017',
        courses: Course.courses_by_day_and_term('meets_on_monday', term_name, term_year).first(5)
      },
      {
        day: 'Summer 2017',
        courses: Course.courses_by_day_and_term('meets_on_tuesday', term_name, term_year).first(5)
      },
      {
        day: 'Spring 2017',
        courses: Course.courses_by_day_and_term('meets_on_wednesday', term_name, term_year).first(5)
      },
      {
        day: 'Fall 2018',
        courses: Course.courses_by_day_and_term('meets_on_thursday', term_name, term_year).first(5)
      },
      {
        day: 'Summer 2018',
        courses: Course.courses_by_day_and_term('meets_on_friday', term_name, term_year).first(5)
      }
    ]
    render json: courses
  end

  def events_by_date
    Course.where(created_at: @selected_date.beginning_of_day..@selected_date.end_of_day)
  end

  def fullsearch
    # query_filters = {
    #   term: params[:term],
    #   keywords: params[:keywords],
    #   keyword_options: params[:keyword_options] || { "0": [] },
    #   keyword_weights: params[:keyword_weights],
    #   school: params[:school],
    #   department: params[:department],
    #   subject: params[:subject],
    #   type: params[:type],
    #   units: {
    #     min: params[:units_min],
    #     max: params[:units_max]
    #   },
    #   times: Course.schedule_filter_map(params)
    # }

    # @nav = :catalog
    # @matching_courses ||= []
    # @course_groups ||= []
    # @user_course_ids = [] # current_user.courses.all.map(&:id)

    # if query_filters.present?
    #   @keyword_filters = build_keyword_filters(query_filters)

    #   query = sunspot_search(query_filters, :courses)
    #   @matching_courses = query.results
    #   @matching_course_ids = @matching_courses.map(&:id)

    # else
    #   @keyword_filters = [{ keywords: '', keyword_options: '' }]
    # end
    # render json: @matching_courses, methods: %i[meeting instructor]
    render json: data.as_json
  end

  def clear_search
    session.delete(:query_filters)
    redirect_to '/'
  end

  # add course to current user's tray
  def add_to_tray
    course = Course.find(params["id"])
    user_course = UserCourse.find_or_create_by(user_id: current_user.id, course_id: course.id)
    render json: user_course
  end

  # remove course from current user's tray
  def remove_from_tray
    course = Course.find(params["id"])

    if (user_course = UserCourse.find_by(user_id: current_user.id, course_id: course.id))
      user_course.destroy
    end

    render json: user_course
  end

  # add course meeting pattern to current user's schedule
  def add_to_schedule
    pattern = CourseMeetingPattern.find(params[:pattern_id])

    user_course = UserCourse.find_or_initialize_by(
      user_id: current_user.id,
      course_id: pattern.course_id,
      course_meeting_pattern_id: [nil, pattern.id]
    )

    user_course.course_meeting_pattern_id = pattern.id
    user_course.include_in_path = true
    user_course.save

    render json: user_course

  end

  # remove course meeting pattern from current user's schedule
  def remove_from_schedule
    pattern = CourseMeetingPattern.find(params[:pattern_id])

    if (user_course = UserCourse.find_by(user_id: current_user.id, course_meeting_pattern_id: pattern.id))
      user_course.course_meeting_pattern_id = nil
      user_course.include_in_path = false
      user_course.save
    end

    render json: user_course
  end

  # get user's course data
  def user_courses
    tray = current_user.courses

    # organize the existing courses into days of the week
    @meeting_patterns_per_day = {
      monday: current_user.patterns_for_all_courses( by_day: :monday).to_a,
      tuesday: current_user.patterns_for_all_courses( by_day: :tuesday).to_a,
      wednesday: current_user.patterns_for_all_courses( by_day: :wednesday).to_a,
      thursday: current_user.patterns_for_all_courses( by_day: :thursday).to_a,
      friday: current_user.patterns_for_all_courses( by_day: :friday).to_a
    }

    # organize the existing courses into years/semesters
    @meeting_patterns_per_year = []
    semester_map.each do |year|
      column = {}
      year.each do |sem|
        column[:"#{sem}"] = current_user.patterns_for_all_courses(by_term: sem).to_a
      end
      @meeting_patterns_per_year << column
    end

    user_courses = {
      :tray => JSON.parse(tray.to_json(methods: %i[meeting instructor user_tags user_annotations user_schedule])),
      :semester => JSON.parse(@meeting_patterns_per_day.to_json(methods: %i[meeting instructor user_tags user_annotations user_schedule])),
      :multi_year => JSON.parse(@meeting_patterns_per_year.to_json(methods: %i[meeting instructor user_tags user_annotations user_schedule]))
    }
    render json: user_courses
  end

  private

  def data
      [
    {
      "id": 328304,
      "external_course_id": 135598,
      "title": "Engineering Thermodynamics sd asda",
      "term_name": "1931 Fall",
      "term_year": 2017,
      "academic_year": 2018,
      "class_section": nil,
      "component": "Discussion",
      "prereq": nil,
      "subject": "ENG-SCI",
      "subject_description": "Engineering Sciences",
     "subject_academic_org_description": "Engineering Sciences",
      "academic_group": "FAS",
      "academic_group_description": "Faculty of Arts & Sciences",
      "grading_basis_description": nil,
      "term_pattern_code": "FA",
      "term_pattern_description": "Fall Only",
      "units_maximum": 4,
      "catalog_number": 181,
      "course_description": "Engineering Thermodynamics",
      "course_description_long": "<p>Introduction to classical engineering thermodynamics. Topics: Zeroth Law and temperature. Properties of single-component gases",
      "course_note": nil,
      "created_at": "2017-12-21T15:10:47.554-05:00",
      "updated_at": "2017-12-21T15:10:47.554-05:00",
      "class_academic_org_description": nil,
      "division": "misc",
      "division_description": "Misc",
      "meeting": {
        "id": 292470,
        "external_course_id": 135598,
        "course_id": 328304,
        "term_name": "Fall",
        "term_year": 2017,
        "class_section": "1",
        "class_meeting_number": "1",
        "meeting_time_start": DateTime.now,
        "meeting_time_end": DateTime.now + 1.hours,
        "meets_on_monday": false,
        "meets_on_tuesday": true,
        "meets_on_wednesday": false,
        "meets_on_thursday": true,
        "meets_on_friday": false,
        "meets_on_saturday": false,
        "meets_on_sunday": false,
        "start_date": "2017-08-30",
        "end_date": "2017-12-01",
        "external_facility_id": nil,
        "facility_description": nil,
        "created_at": "2017-12-21T16:08:09.294-05:00",
        "updated_at": "2017-12-21T16:08:09.294-05:00"
      },
      "instructor": {
        "id": 482601,
        "external_course_id": 135598,
        "course_id": 328304,
        "term_name": "Fall",
        "term_year": 2017,
        "class_section": "1",
        "class_meeting_number": "1",
        "instructor_role": "HEAD",
        "print_instructor_flag": "Y",
        "first_name": "Michael",
        "middle_name": "J.",
        "last_name": "Aziz",
        "name_prefix": nil,
        "name_suffix": nil,
        "email": "maziz@harvard.edu",
        "created_at": "2017-12-21T16:59:17.693-05:00",
        "updated_at": "2017-12-21T16:59:17.693-05:00"
      },
      "tags": ['tag1', 'tag2', 'tag3'],
      "course_reading":
      {
        "id"=>1,
        "external_course_id"=>132559,
        "external_citation_id"=>nil,
        "course_id"=>5,
        "title"=>"Reading",
        "author_last_name"=>"John",
       "author_first_name"=>"DEO",
        "url"=>nil,
        "annotation"=>" sdaf;sakd;f dsakf;lks;adkf;l ksad'flsakdf; k'sadf;lsjadf sadfsadfdsa 1111111",
        "required"=>false
      }
    },
    {
    "id": 328304,
    "external_course_id": 135598,
    "title": "Engineering Thermodynamics",
    "term_name": "Fall",
    "term_year": 2017,
    "academic_year": 2018,
    "class_section": nil,
    "component": "Discussion",
    "prereq": nil,
    "subject": "ENG-SCI",
    "subject_description": "Engineering Sciences",
    "subject_academic_org_description": "Engineering Sciences",
    "academic_group": "FAS",
    "academic_group_description": "Faculty of Arts & Sciences",
    "grading_basis_description": nil,
    "term_pattern_code": "FA",
    "term_pattern_description": "Fall Only",
    "units_maximum": 4,
    "catalog_number": 181,
    "course_description": "Engineering Thermodynamics",
    "course_description_long": "<p>Introduction to classical engineering thermodynamics. Topics: Zeroth Law and temperature. Properties of single-component gases, ",
    "course_note": nil,
    "created_at": "2017-12-21T15:10:47.554-05:00",
    "updated_at": "2017-12-21T15:10:47.554-05:00",
    "class_academic_org_description": nil,
    "division": "misc",
    "division_description": "Misc",
    "meeting": {
      "id": 292470,
      "external_course_id": 135598,
      "course_id": 328304,
      "term_name": "Fall",
      "term_year": 2017,
      "class_section": "1",
      "class_meeting_number": "1",
      "meeting_time_start": DateTime.now,
      "meeting_time_end": DateTime.now + 1.hours,
      "meets_on_monday": false,
      "meets_on_tuesday": true,
      "meets_on_wednesday": false,
      "meets_on_thursday": true,
      "meets_on_friday": false,
      "meets_on_saturday": false,
      "meets_on_sunday": false,
      "start_date": "2017-08-30",
     "end_date": "2017-12-01",
      "external_facility_id": nil,
      "facility_description": nil,
      "created_at": "2017-12-21T16:08:09.294-05:00",
      "updated_at": "2017-12-21T16:08:09.294-05:00"
    },
    "instructor": {
      "id": 482601,
      "external_course_id": 135598,
     "course_id": 328304,
      "term_name": "Fall",
      "term_year": 2017,
      "class_section": "1",
      "class_meeting_number": "1",
      "instructor_role": "HEAD",
      "print_instructor_flag": "Y",
      "first_name": "Michael",
      "middle_name": "J.",
      "last_name": "Aziz",
      "name_prefix": nil,
      "name_suffix": nil,
      "email": "maziz@harvard.edu",
      "created_at": "2017-12-21T16:59:17.693-05:00",
      "updated_at": "2017-12-21T16:59:17.693-05:00"
    },
    "tags": ['tag1', 'tag2', 'tag3'],
    "course_reading":
    {
      "id"=>1,
      "external_course_id"=>132559,
      "external_citation_id"=>nil,
      "course_id"=>5,
      "title"=>"Reading",
      "author_last_name"=>"John",
      "author_first_name"=>"DEO",
      "url"=>nil,
      "annotation"=>" sdaf;sakd;f dsakf;lks;adkf;l ksad'flsakdf; k'sadf;lsjadf adfsadfdsa 1111111",
      "required"=>false    }
  }
]

  end
end
