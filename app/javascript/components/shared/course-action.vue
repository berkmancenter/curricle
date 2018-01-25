<template>
  <span class="course-action">
    <i
      :class="calcClass"
      @click="click"
      v-b-tooltip.hover="true"
      :title="tooltip"
    />
  </span>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  props: {
    type: {
      type: String,
      required: true
    },
    course: {
      type: String,
      required: true
    },
    clickHandler: {
      type: Function,
      required: false,
      default: null
    }
  },
  data () {
    return {
      types: {
        tray: {
          icon: 'fa-folder',
          clickable: true,
          activeTooltip: 'Click to remove from your tray',
          inactiveTooltip: 'Click to add to your tray'
        },
        schedule: {
          icon: 'fa-clock-o',
          clickable: true,
          activeTooltip: 'Click to remove from your schedule',
          inactiveTooltip: 'Click to add to your schedule'
        },
        annotated: {
          icon: 'fa-pencil',
          clickable: false,
          activeTooltip: 'You have annotated this course',
          inactiveTooltip: 'You have not annotated this course'
        },
        tagged: {
          icon: 'fa-tag',
          clickable: false,
          activeTooltip: 'This course has tags',
          inactiveTooltip: 'This course has no tags'
        },
        shareable: {
          icon: 'fa-share-alt',
          clickable: false,
          activeTooltip: 'Click to share this course',
          inactiveTooltip: ''
        }
      },
      active: false
    }
  },
  computed: {
    tooltip () {
      return this.active ? this.config.activeTooltip : this.config.inactiveTooltip
    },
    config () {
      return this.types[this.type]
    },
    calcClass () {
      var theClass = { fa: true, active: this.active }
      theClass[this.config.icon] = true

      return theClass
    }
  },
  mounted () {
    this.courseHasStatus({ type: this.type, course: this.course }).then(
      ret => { this.active = ret }
    )
  },
  methods: {
    ...mapActions('user', ['courseHasStatus', 'toggleCourseStatus']),
    click () {
      if (this.config.clickable || this.clickHandler) {
        if (this.clickHandler) {
          this.clickHandler({ type: this.type, course: this.course })
        } else {
          // default toggleable click handler
          this.toggleCourseStatus({ type: this.type, course: this.course }).then(
            () => this.courseHasStatus({ type: this.type, course: this.course }).then(
              ret => { this.active = ret }
            )
          )
        }
      }
    }
  }
}

</script>

<style>
.course-action {
    color: gray;
}

.course-action .active {
    color: black;
}
</style>
