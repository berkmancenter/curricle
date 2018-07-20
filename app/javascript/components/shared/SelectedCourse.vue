<template>
  <div
    id="selected-course"
    class="pt-3 px-3">

    <div>
      <span class="float-left">
        Selected course
      </span>

      <span class="float-right">
        <font-awesome-icon
          class="pointer"
          icon="times"
          @click="closeSidebar"/>
      </span>
    </div>

    <hr>

    <div
      v-if="userAuthenticated"
      class="actions mb-0">
      <p class="float-left">
        <course-action
          :course="theCourse.id"
          :invert="true"
          type="tray"/>
        <course-action
          :course="theCourse.id"
          :invert="true"
          type="schedule"/>
      </p>

      <p class="course-history float-right text-right">
        <a
          href="javascript:"
          @click="searchByCourseId(courseId)">
          See course history
        </a>
      </p>
    </div>

    <selected-course-details
      :course="theCourse"
    />

    <selected-course-tagging
      :active-tags="theCourse.user_tags"
      :course-id="theCourse.id"
      @deactivateTag="deactivateTag($event)" />
  </div>
</template>

<script>
import { mapActions, mapState, mapGetters } from 'vuex'
import { serializeSearch } from 'lib/util'
import CourseAction from 'components/shared/CourseAction'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import SelectedCourseDetails from 'components/shared/SelectedCourseDetails'
import SelectedCourseTagging from './SelectedCourseTagging'

export default {
  components: {
    serializeSearch,
    CourseAction,
    FontAwesomeIcon,
    SelectedCourseDetails,
    SelectedCourseTagging
  },
  props: {
    course: {
      type: [String, Number, Object],
      required: true
    }
  },
  computed: {
    ...mapState('courses', ['courses']),
    ...mapGetters('user', ['userAuthenticated']),
    theCourse () {
      if (typeof this.course === 'object') {
        return this.course
      }
      return this.courses[this.course]
    },
    courseId () {
      return `${this.theCourse.subject} ${this.theCourse.catalog_number}`
    }
  },
  methods: {
    ...mapActions('app', ['closeSidebar']),
    searchByCourseId (courseId) {
      this.$store.dispatch('search/searchByCourseId', courseId)
      this.$router.push('/search/' + serializeSearch(this.$store.getters['search/searchSnapshot']))
    }
  }
}
</script>

<style lang="scss" scoped>
  .actions {
    display: inline-block;
    width: 100%;
  }

  #selected-course {
    color: #fff;
  }

  p.course-history {
    font-size: 13px;
    font-weight: bold;

    a {
      color: #fff;
    }
  }

  .pointer {
    cursor: pointer;
  }
</style>
