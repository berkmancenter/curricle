<template >
  <div class="description">
    <div class="row margin-none">
      <p class="pull-left"><b>{{ course.academic_group }}</b></p>
      <p class="pull-right">Component: <span><b>{{ course.component }}</b></span></p>
    </div>
    <div class="row margin-none">
      <p class="pull-left"><b>{{ course.term_name }}</b></p>
      <p class="pull-right">Grading basis: <span><b>{{ course.grading_basis_description }}</b></span></p>
    </div>
    <div class="row margin-none">
      <p class="pull-left"><b>{{ course.external_course_id }}</b></p>
      <p class="pull-right">Instructor: <span><b>{{ course.instructor.first_name }}</b></span></p>
    </div>
    <div class="heading">{{ course.class_academic_org_description }}</div>
    <div class="second-description">
      <p>Description</p>
      <p v-html="course.course_description_long"/>
    </div>
    <div class="instruction">
      <p>Instruction</p>
      <div class="row margin-none">
        <p class="pull-left"><b>{{ course.instructor.first_name }} {{ course.instructor.last_name }}</b></p>
        <p class="pull-right">More Courses</p>
      </div>
    </div>
    <div class= "reading">
      <p>Reading</p>
      <div class="annotation-border">
        <div class="annotations">
          <p><span class="fa fa-pencil" @click="OpenAnnotationsForm()"/><b>Annotations</b></p>
        </div>
        <div class= "annonation-tag">
          <tags
            :active-tags="course.user_tags"
            :tag="tag"
            :course-id="course.id"
            @deactivateTag="deactivateTag($event)" />
          <div v-if="!editableAnnotations">
            <p>
              {{editableAnnotationsText}}
            </p>
            <div class= "annonation-tag">
              <ul>
                <li v-for="(text, index) of annotationTags">
                  {{ text }} <span class=""/>
                </li>
              </ul>
            </div>
          </div>
          <div v-else>
            <p>
              <textarea rows="10" style="width: 100%"  v-model="editableAnnotationsText">
              </textarea>
              <input
                placeholder="Enter Tag"
                v-model="tag"
                @keyup.enter="addTags">
              <span
                class=""
                v-for="(text, index) of annotationTags"
                @click="removeTags(index)">
                {{ text }}&nbsp;&nbsp;<font-awesome-icon icon="times"/>
              </span>

              <button @click="updateAnnotations">Save</button>
            </p>
          </div>    
        </div>
      </div>
    </div>
  </div>
</template>

<script type="text/javascript">
import Tags from './tags.vue'
import axios from 'axios'
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'

export default {
  components: {
    FontAwesomeIcon,
    Tags
  },

  props: ['course'],

  data () {
    return {
      editableAnnotations: false,
      editableAnnotationsText: "",
      annotationTags: [],
      tag: ""
    }
  },

  watch: {
    course: function () {
      this.editableAnnotationsText = this.course.course_reading.annotation
      this.annotationTags = this.course.tags
    }
  },

  methods: {
    OpenAnnotationsForm(){
      this.editableAnnotations = !this.editableAnnotations
    },

    updateAnnotations(){
      const data = { course_reading: { annotation: this.editableAnnotationsText } }

      axios.patch(`/course_readings/${this.course.course_reading.id}`, data).then((response) => {
        this.course.course_reading = response.data
        this.editableAnnotations = !this.editableAnnotations
        this.tag = ""
      })
    },

    addTags() {
      if (this.tag) {
        this.annotationTags.push(this.tag)
      }

      this.tag = ''
    },

    removeTags(index){
      this.annotationTags.splice(index, 1)
    }
  }
}
</script>

<style>
  .bottom-border {
    border-bottom: 1px gray solid;
  }
  .description {
    display: inline-block;
    width: 100%;
  }
  .description .margin-none {
    display: inline-block;
    width: 100%;
    text-align: right;
    font-size: 12px;
  }
  .description .margin-none p {
  margin-bottom: 0px;
  line-height: 100%;
  }
  .description .margin-none p:nth-child(2) {
    text-align: right;
  }
  .description .margin-none:nth-child(2) p {
    margin-top: -25px;
  }
  .description .margin-none:nth-child(3) p {
    margin-top: -38px;
  }
  .heading {
    display: inline-block;
    width: 100%;
    font-size: 22px;
    color:#ff00ff;
    line-height: 1;
    margin-bottom: 20px;
  }
  .instruction .margin-none{
    display: inline-block;
    width: 100%;
    text-align: right;
    border-bottom: 1px solid #bcbaba;
  }
  .instruction {
     display: inline-block;
    width: 100%;
  }
  .instruction  .margin-none p:nth-child(2) {
    text-align: right;
  }
  .annotations {
    display: inline-block;
    width: 100%;
    text-align: center;
  }
  .annotations p span {
    display: inline-block;
    text-align: left;
    float: left;
    font-size: 25px;
    color: #ff00ff;
  }
  .annotation-border {
    border: 1px solid #000;
    padding: 20px;
    border-radius: 5px;
  }
  .annotation-para p {
    text-align: justify;
  }
  .second-description p:nth-child(3) {
    margin-bottom: 30px;
  }
  .reading p:nth-child(1) {
    margin-bottom: 0px;
    margin-top:
  }
</style>
