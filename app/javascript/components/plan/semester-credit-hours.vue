<template>
  <b-row class="mt-5">
    <b-col>
      <b-row>
        <b-col class="font-weight-bold">
          {{ semester }}

          <hr>
        </b-col>
      </b-row>

      <b-row
        v-for="course in courses"
        :key="course.index"
        :class="{ selected: currentCourse && currentCourse.id === course.id }"
        class="mb-1 mx-1 pointer"
        @click="selectCourse(course)">
        <b-col
          cols="6"
          class="text-uppercase font-weight-bold">
          {{ course.title }}
        </b-col>

        <b-col
          cols="2"
          class="text-muted">
          {{ firstInstructorName(course) }}
        </b-col>

        <b-col
          cols="2"
          class="text-muted text-uppercase">
          {{ course.subject }} {{ course.catalog_number }}
        </b-col>

        <b-col
          cols="2"
          class="text-muted text-uppercase">
          {{ course.component }}
        </b-col>
      </b-row>
    </b-col>
  </b-row>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'

export default {
  props: {
    courses: {
      type: Array,
      required: true
    },
    semester: {
      type: String,
      required: true
    }
  },
  computed: {
    ...mapGetters('app', ['currentCourse'])
  },
  methods: {
    ...mapActions('app', ['selectCourse']),
    firstInstructorName (course) {
      if (course.course_instructors.length) {
        return course.course_instructors[0].display_name
      } else {
        return 'Instructor TBD'
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.pointer {
  cursor: pointer;
}

.selected {
  background-color: black;
  color: white;
  border-radius: 4px;

  .text-muted {
    color: #c0c0c0 !important;
  }
}
</style>
