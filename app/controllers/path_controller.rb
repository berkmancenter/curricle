class PathController < ApplicationController
  before_action :require_auth

  def index
    filters = generate_filters
    semester = filters.present? ? filters[:term] : current_semester(safe: true)
    @meeting_patterns = current_user.patterns_for_all_courses()

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

    if filters.present?
      # generate recommendations and add them to the various datasets as appropriate

      @keywords = filters[:keywords]

      # search for courses that match the filters and haven't already been added
      query = CourseMeetingPattern.joins(:course)
      query = query.where(course_id: Course.search_for(filters).select(:id))
        .where.not(id: @meeting_patterns.map(&:id))

      # exlude any courses without meeting times
      query = query.where('meeting_time_start is not null and meeting_time_end is not null')

      # exclude any courses that would overlap existing courses
      @meeting_patterns_per_day.each do |day, patterns|
        patterns.each do |pattern|
          next unless current_user.in_path?(pattern.id)
          query = query.where(
            "meets_on_#{day} is false OR (meeting_time_end <= ? OR meeting_time_start >= ?)",
            pattern.meeting_time_start,
            pattern.meeting_time_end
          )
        end
      end

      # exclude any courses the user has explicitly discarded
      if filters[:excludes].present?
        query = query.where.not(id: filters[:excludes])
      end

      # apply the user's search filters
      query = apply_common_filters(query, filters)

      recommendations = []
      available = query.to_a.shuffle
      units_remaining = filters[:units][:total].to_i
      while units_remaining > 0 && available.length > 0 do
        available.delete_if { |r| r.course.units_maximum > units_remaining }
        rec = available.pop
        break if rec.nil?

        recommendations << rec
        units_remaining -= rec.course.units_maximum

        available.keep_if { |r|
          (r.meets_on_monday == false || r.meets_on_monday != rec.meets_on_monday || (r.meeting_time_start >= rec.meeting_time_end || r.meeting_time_end <= rec.meeting_time_start)) &&
          (r.meets_on_tuesday == false || r.meets_on_tuesday != rec.meets_on_tuesday || (r.meeting_time_start >= rec.meeting_time_end || r.meeting_time_end <= rec.meeting_time_start)) &&
          (r.meets_on_wednesday == false || r.meets_on_wednesday != rec.meets_on_wednesday || (r.meeting_time_start >= rec.meeting_time_end || r.meeting_time_end <= rec.meeting_time_start)) &&
          (r.meets_on_thursday == false || r.meets_on_thursday != rec.meets_on_thursday || (r.meeting_time_start >= rec.meeting_time_end || r.meeting_time_end <= rec.meeting_time_start)) &&
          (r.meets_on_friday == false || r.meets_on_friday != rec.meets_on_friday || (r.meeting_time_start >= rec.meeting_time_end || r.meeting_time_end <= rec.meeting_time_start))
        }
      end

      # add generated courses to the datasets of existing courses
      recommendations.each do |rec|
        @meeting_patterns_per_day[:monday] << rec if rec.meets_on_monday
        @meeting_patterns_per_day[:tuesday] << rec if rec.meets_on_tuesday
        @meeting_patterns_per_day[:wednesday] << rec if rec.meets_on_wednesday
        @meeting_patterns_per_day[:thursday] << rec if rec.meets_on_thursday
        @meeting_patterns_per_day[:friday] << rec if rec.meets_on_friday

        @meeting_patterns_per_year.each do |year|
          year.each do |sem, patterns|
            #patterns << rec if rec.semester == sem.to_s
            patterns.unshift(rec) if rec.semester == sem.to_s
          end
        end
      end
    end
  end

  def generate
    session[:generate_filters] = {
      excludes: [],
      term: params[:term] || '',
      keywords: params[:keywords] || '',
      keyword_options: params[:keyword_options] || [],
      school: params[:school],
      department: params[:department],
      subject: params[:subject],
      type: params[:type],
      units: {
        min: params[:units_min],
        max: params[:units_max],
        total: params[:units_total]
      }
    }

    redirect_to '/path'
  end

  # add course meeting pattern to current user's path
  def add
    @pattern = CourseMeetingPattern.find(params[:pattern_id])

    user_course = UserCourse.find_or_initialize_by(
      user_id: current_user.id,
      course_id: @pattern.course_id,
      course_meeting_pattern_id: [nil, @pattern.id]
    )

    user_course.course_meeting_pattern_id = @pattern.id
    user_course.include_in_path = true
    user_course.save

    respond_to do |format|
      format.html { redirect_to '/path' }
      format.js
    end
  end

  # remove course meeting pattern from current user's path
  def remove
    @pattern = CourseMeetingPattern.find(params[:pattern_id])

    user_course = UserCourse.find_or_initialize_by(
      user_id: current_user.id,
      course_id: @pattern.course_id,
    )

    if user_course = UserCourse.find_by(user_id: current_user.id, course_meeting_pattern_id: @pattern.id)
      user_course.course_meeting_pattern_id = nil
      user_course.include_in_path = false
      user_course.save
    end

    respond_to do |format|
      format.html { redirect_to '/path' }
      format.js
    end
  end

  # exclude course meeting pattern from recommendation results
  def discard_recommendation
    @pattern = CourseMeetingPattern.find(params[:pattern_id])

    session[:generate_filters]["excludes"] << @pattern.id

    respond_to do |format|
      format.html { redirect_to '/path' }
      format.js
    end
  end

  # clear out the generate filters and recommendations
  def clear_search
    session.delete(:generate_filters)
    redirect_to '/path'
  end
end
