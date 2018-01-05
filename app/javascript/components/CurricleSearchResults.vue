<template>
  <div
    class="row curricle-search-result"
    :style="borderStyle">
    <div class="col-md-1">
      <i class="fa fa-folder" @click="addRemoveCourse(id)"  v-bind:class="{ usercourse:   !isBelongsToUser(id)}"/><br>
      <i class="fa fa-clock-o" @click="addRemoveSchedule(meeting.id)"  v-bind:class="{ userschedule: !isMeetingBelongsToUser(meeting.id)}" v-if="meeting"/>
    </div>
    <div class="col-md-2">
      <strong>
        {{ academic_group }}
        <br>
        {{ subject }} {{ catalog_number }}
        <br>
        {{ term_name }} {{ term_year }}
        <br>
        {{ units_maximum }} Units
      </strong>
    </div>
    <div class="col-md-2">
      Component: <strong>{{ component }}</strong>
      <br>
      Grading Basis:
      <br>
      Instructor:
    </div>
    <div class="col-md-6">
      <h5>{{ title }}</h5>
      <span v-html="description"/>
    </div>
    <div class="col-md-2">
      Schedule
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  props: {
    academic_group: {
      type: String,
      required: true
    },
    catalog_number: {
      type: Number,
      required: true
    },
    component: {
      default: '',
      type: String
    },
    description: {
      type: String,
      default: ''
    },
    id: {
      type: String,
      required: true
    },
    subject: {
      type: String,
      required: true
    },
    term_name: {
      type: String,
      required: true
    },
    term_year: {
      type: Number,
      required: true
    },
    title: {
      type: String,
      required: true
    },
    units_maximum: {
      type: Number,
      required: true
    },
    meeting: {
      type: Object
    },
    getUserCourses: {
      type: Function
    },
    isBelongsToUser: {
      type: Function
    },
    isMeetingBelongsToUser: {
      type: Function
    }
  },
  computed: {
    borderStyle () {
      // TODO: map course color to data
      const randomColor = Math.floor((Math.random() * (999 - 599)) + 600)

      return {
        'border-left-color': ('#' + randomColor)
      }
    }
  },
  methods: {
    addRemoveCourse (courseId) {
      if(this.isBelongsToUser(this.id)){
        axios
        .delete("/courses/remove_from_tray", {params: {id: courseId} })
        .then((response) => {
          this.getUserCourses()
        })
      }else{
        axios
        .post("/courses/add_to_tray", {id: courseId})
        .then((response) => {
          this.getUserCourses()
        })
      }
    },
    addRemoveSchedule (courseId) {
      const url = "/courses/add_to_schedule"
      if(this.isMeetingBelongsToUser(this.id)){
        axios
        .delete("/courses/remove_from_tray", {params: {id: courseId} })
        .then((response) => {
          this.getUserCourses()
        })
      }else{
        axios
        .post("/courses/add_to_schedule", {id: courseId})
        .then((response) => {
          this.getUserCourses()
        })
      }
    },
  }
}
</script>

<style lang="scss" scoped>
.curricle-search-result {
  font-size: 13px;
  border-left-width: 10px;
  border-left-style: solid;
  border-top: 1px solid #ccc;
  margin-left: 0;
  padding-top: 10px;

  h5 {
    font-size: 16px;
  }
}
.usercourse, .userschedule {
  color: gray;
}
</style>
