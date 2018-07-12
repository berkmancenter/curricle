<template>
  <span class="course-action">
    <font-awesome-icon
      v-b-tooltip.d999.hover="true"
      :icon="config.icon"
      :class="{ active: active }"
      :title="tooltip"
      @click="click"
    />
  </span>
</template>

<script>
import { mapState } from 'vuex'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import USER_COURSE_REMOVE_MUTATION from '../../graphql/UserCourseRemove.gql'
import USER_COURSE_SET_MUTATION from '../../graphql/UserCourseSet.gql'

export default {
  components: {
    FontAwesomeIcon
  },
  props: {
    type: {
      type: String,
      required: true
    },
    course: {
      type: String,
      required: true
    }
  },
  data () {
    return {
      types: {
        tray: {
          icon: 'folder',
          clickable: true,
          activeTooltip: 'Click to remove from your tray',
          inactiveTooltip: 'Click to add to your tray'
        },
        schedule: {
          icon: 'clock',
          clickable: true,
          activeTooltip: 'Click to remove from your schedule',
          inactiveTooltip: 'Click to add to your schedule'
        },
        annotated: {
          icon: 'pencil-alt',
          clickable: false,
          activeTooltip: 'You have annotated this course',
          inactiveTooltip: 'You have not annotated this course'
        },
        tagged: {
          icon: 'tag',
          clickable: false,
          activeTooltip: 'This course has tags',
          inactiveTooltip: 'This course has no tags'
        },
        shareable: {
          icon: 'share-square',
          clickable: false,
          activeTooltip: 'Click to share this course',
          inactiveTooltip: ''
        }
      }
    }
  },
  computed: {
    ...mapState('user', ['courseflags']),
    active () {
      if (this.type === 'shareable') {
        return true
      }
      return !!this.courseflags[this.type][this.course]
    },
    tooltip () {
      return this.active ? this.config.activeTooltip : this.config.inactiveTooltip
    },
    config () {
      return this.types[this.type]
    }
  },
  methods: {
    click () {
      if (!this.config.clickable) { return }

      if (this.type === 'tray' && this.courseflags[this.type][this.course]) {
        this.removeUserCourse()
      } else {
        this.setUserCourse()
      }
    },
    setUserCourse () {
      var includeInPath = false

      if (this.type === 'schedule') {
        includeInPath = !this.courseflags[this.type][this.course]
      }

      this.$apollo.provider.defaultClient.mutate({
        mutation: USER_COURSE_SET_MUTATION,
        variables: {
          courseId: this.course,
          includeInPath: includeInPath
        }
      }).then(
        this.toggleCourseStatus()
      )
    },
    removeUserCourse () {
      this.$apollo.provider.defaultClient.mutate({
        mutation: USER_COURSE_REMOVE_MUTATION,
        variables: {
          courseId: this.course
        }
      }).then(
        this.toggleCourseStatus()
      )
    },
    toggleCourseStatus () {
      this.$store.dispatch('user/toggleCourseStatus', { type: this.type, course: this.course })
    }
  }
}
</script>

<style scoped>
  .course-action {
      color: gray;
  }

  .course-action .active {
      color: black;
  }

  i.fa {
    cursor: pointer;
  }
</style>
