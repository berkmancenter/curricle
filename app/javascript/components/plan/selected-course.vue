<template>
  <div>
    <div v-if="validCourseSelected">
      <p class="select-course">Selected Course</p>
      <hr>
      <div class="row actions margin-none">
        <i
          class="fa fa-folder-open"
        />
        <i
          class="fa fa-clock-o"
        />
        <i
          class="fa fa-share-alt"
        />
        <div class="pull-right">See Course History</div>
      </div>
      <div class="row margin-none">
        <plan-description/>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import PlanDescription from 'components/plan/plan-description'

export default {
  components: {
    PlanDescription
  },
  computed: {
    ...mapGetters('user', ['validCourseSelected'])
  }
}
</script>
