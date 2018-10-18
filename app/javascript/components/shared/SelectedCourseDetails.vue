<template>
  <div class="course-details">
    <div class="header mx-0">
      <p class="float-left mb-0">
        <strong>{{ course.academic_group }}</strong><br>
        <strong>{{ `${course.subject} ${course.catalog_number}` }}</strong><br>
        <strong>{{ `${course.term_name} ${course.term_year}` }}</strong>
      </p>
      <p class="float-right text-right text-uppercase mb-0">
        <strong>{{ course.component || '&mdash;' }}</strong><br>
        <strong>{{ course.grading_basis_description || '&mdash;' }}</strong><br>
        <strong>{{ firstInstructor || '&mdash;' }}</strong>
      </p>
    </div>

    <h3 class="course-title text-uppercase">{{ course.title }}</h3>

    <div class="description">
      <p class="heading">Description</p>
      <truncate
        v-if="course.course_description_long"
        :length="250"
        :text="course.course_description_long"
        clamp="[...]"
        less="[Close]"
        type="html"
      />
    </div>

    <div
      v-if="course.course_note"
      class="notes mt-4"
    >
      <p
        class="heading"
      >
        Class Notes
      </p>

      {{ course.course_note }}
    </div>

    <div class="instructors mt-4">
      <p class="heading">Instructors</p>
      <div
        v-for="instructor in course.course_instructors"
        :key="instructor.id"
        class="instructor mb-0"
      >
        <p class="float-left mb-0">
          <strong>{{ instructor.display_name }}</strong>
        </p>
        <p class="float-right text-right mb-0">
          <a
            href="javascript:"
            class="text-white"
            @click="searchByInstructor(instructor.display_name)"
          >
            more courses
          </a>
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import truncate from 'vue-truncate-collapsed'
import { serializeSearch } from 'lib/util'

export default {
  components: {
    truncate
  },
  props: {
    course: {
      type: Object,
      required: true
    }
  },
  computed: {
    firstInstructor () {
      if (this.course.course_instructors.length) {
        return this.course.course_instructors[0].display_name
      }
    }
  },
  methods: {
    searchByInstructor (instructorName) {
      this.$store.dispatch('search/searchByInstructor', instructorName)
      this.$router.push('/search/advanced/' + serializeSearch(this.$store.getters['search/searchSnapshot']))
    }
  }
}
</script>

<style lang="scss" scoped>
  .course-details {
    display: inline-block;
    font-size: 12px;
    width: 100%;

    .header {
      display: inline-block;
      line-height: 16px;
      margin-bottom: 20px;
      width: 100%;

      p.float-left {
        clear: left;
        width: 40%;
      }

      p.float-right {
        clear: right;
        width: 60%;
      }
    }

    h3.course-title {
      font-size: 18px;
      margin-bottom: 20px;
    }

    p.heading {
      border-bottom: 1px solid #999;
      margin-bottom: 8px;
    }

    .instructors {
      display: inline-block;
      width: 100%;

      .instructor {
        border-bottom: 1px solid #999;
        display: inline-block;
        padding: 4px 0;
        width: 100%;
      }
    }
  }
</style>
