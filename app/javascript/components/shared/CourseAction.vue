<template>
  <span class="course-action">
    <font-awesome-icon
      v-b-tooltip.d999.hover="true"
      :icon="icon"
      :class="{ 'text-white': invert }"
      :title="tooltip"
      class="pointer"
      @click.stop="click"
    />
  </span>
</template>

<script>
import { mapMutations, mapState } from 'vuex'
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
    },
    invert: {
      type: Boolean,
      default: false
    }
  },
  data () {
    return {
      types: {
        tray: {
          activeIcon: 'minus',
          inactiveIcon: 'plus',
          clickable: true,
          activeTooltip: 'Click to remove from your schedule',
          inactiveTooltip: 'Click to add to your schedule'
        },
        schedule: {
          activeIcon: 'eye',
          inactiveIcon: ['far', 'eye-slash'],
          clickable: true,
          activeTooltip: 'Click to hide from your schedule',
          inactiveTooltip: 'Click to show in your schedule'
        },
        annotated: {
          activeIcon: 'pencil-alt',
          inactiveIcon: 'pencil-alt',
          clickable: false,
          activeTooltip: 'You have annotated this course',
          inactiveTooltip: 'You have not annotated this course'
        },
        imported: {
          activeIcon: 'lock',
          clickable: false,
          activeTooltip: 'You enrolled in this course in a past semester'
        },
        tagged: {
          activeIcon: 'tag',
          inactiveIcon: 'tag',
          clickable: false,
          activeTooltip: 'This course has tags',
          inactiveTooltip: 'This course has no tags'
        },
        shareable: {
          activeIcon: 'share-square',
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
    },
    icon () {
      return this.active ? this.config.activeIcon : this.config.inactiveIcon
    }
  },
  methods: {
    ...mapMutations('app', ['SET_ALERT_TEXT']),
    click () {
      if (!this.config.clickable) { return }

      if (this.type === 'tray' && this.courseflags[this.type][this.course]) {
        this.removeUserCourse()
      } else {
        this.setUserCourse()
      }
    },
    setUserCourse () {
      let includeInPath = !this.courseflags['schedule'][this.course]
      let alertText = ''

      if (this.type === 'schedule') {
        alertText = includeInPath ? 'Course shown in schedule' : 'Course hidden from schedule'
      } else {
        alertText = 'Course added to schedule'
      }

      this.$apollo.provider.defaultClient.mutate({
        mutation: USER_COURSE_SET_MUTATION,
        variables: {
          courseId: this.course,
          includeInPath: includeInPath
        }
      }).then(
        this.toggleCourseStatus(alertText)
      )
    },
    removeUserCourse () {
      this.$apollo.provider.defaultClient.mutate({
        mutation: USER_COURSE_REMOVE_MUTATION,
        variables: {
          courseId: this.course
        }
      }).then(
        this.toggleCourseStatus('Course removed from schedule')
      )
    },
    toggleCourseStatus (alertText) {
      this.SET_ALERT_TEXT(alertText)

      this.$store.dispatch('user/toggleCourseStatus', { type: this.type, course: this.course })
    }
  }
}
</script>

<style scoped>
  .course-action {
    color: black;
  }

  i.fa {
    cursor: pointer;
  }
</style>
