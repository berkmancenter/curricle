<template>
  <span/>
</template>

<script>
/* a note here: this component serves to act solely as a watcher of
/* the user's course ids and update the user's state.courses with any
/* that do not already exist.  We have to do it this way because Vuex
states do not support "watching" directly, so we instantiate a
singleton component that just watches and handles the dispatching. */

import { mapState, mapActions } from 'vuex'
import _ from 'lodash'

function loadMissing (vm, val) {
  var obj = {}
  _.each(
    _.keys(val),
    k => {
      if (val[k] && vm.userCourses && !vm.userCourses[k]) {
        if (vm.courses[k]) {
          obj[k] = vm.courses[k]
        }
      }
    }
  )
  if (obj && Object.keys(obj).length) {
    vm.appendCourses(obj)
  }
}

export default {
  computed: {
    ...mapState('user', { courseflags: 'courseflags', userCourses: 'courses' }),
    ...mapState('courses', ['courses'])
  },
  watch: {
    'courseflags.tray': {
      handler (val) { loadMissing(this, val) },
      deep: true
    },
    'courseflags.schedule': {
      handler (val) { loadMissing(this, val) },
      deep: true
    }
  },
  methods: {
    ...mapActions('user', ['appendCourses'])
  }
}
</script>
