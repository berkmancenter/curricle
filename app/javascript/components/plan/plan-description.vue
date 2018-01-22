<template >
  <div
    class="description"
    v-if="isPresent">
    <div class="row margin-none">
      <p class="pull-left"><b>{{ course.academic_group }}</b></p>
      <p class="pull-right">Component: <span><b>{{ course.component }}</b></span></p>
    </div>
    <div class="row margin-none">
      <p class="pull-left"><b>{{ course.term_name }}</b></p>
      <p class="pull-right">Grading basis: <span><b>{{ course.grading_basis_description }}</b></span></p>
    </div>
    <!--     <div class="row margin-none">
      <p class="pull-left"><b>{{ course.external_course_id }}</b></p>
      <p class="pull-right">Instructor: <span><b>{{ course.instructor.first_name }}</b></span></p>
    </div> -->
    <div class="heading">{{ course.class_academic_org_description }}</div>
    <div class="second-description">
      <p>Description</p>
      <p v-html="course.course_description_long"/>
    </div>
    <!-- <div class="instruction">
      <p>Instruction</p>
      <div class="row margin-none">
        <p class="pull-left"><b>{{ course.instructor.first_name }} {{ course.instructor.last_name }}</b></p>
        <p class="pull-right">More Courses</p>
      </div>
    </div> -->
    <div class= "reading">
      <p>Reading</p>
      <div class="annotation-border">
        <div class="annotations">
          <p class="annotations-up-arrow">
            <i
              class="fa fa-caret-up"
              v-if="!isExpand"
              @click="expand()"/>
          </p>
          <p
          :class="{ 'annotations-margin-top': isExpand }">
            <span
              class="fa fa-pencil edit-annotation"
              @click="OpenAnnotationsForm()"/>
            <b>Annotations</b>
          </p>
        </div>
        <div
          class= "annonation-tag"
          v-if="isExpand">
          <div
            v-if="!editableAnnotations"
            style="word-wrap: break-word;">
            <p>
              {{ editableAnnotationsText }}
            </p>
            <tags
              :active-tags="course.user_tags"
              :tag="tag"
              :course-id="course.id"
              @deactivateTag="deactivateTag($event)" />
          </div>
          <div v-else>
            <p>
              <textarea
                rows="10"
                style="width: 100%"
                maxlength="500"
                v-model="editableText"/>
              <span class="word-count">{{ editableTextlength }} / {{ maxLength }} characters</span>
              <span
                class=""
                v-for="(text, index) of annotationTags"
                @click="removeTags(index)"
                :key="index">
                {{ text }}&nbsp;&nbsp;<font-awesome-icon icon="times"/>
              </span>
            </p>
            <div class="save-btn">
              <button @click="updateAnnotations">Update</button>
              <button @click="cancelAnnotations">Cancel</button>
            </div>
          </div>
        </div>
        <div>
          <p class="annotations-down-arrow">
            <i
              class="fa fa-caret-down"
              :class="{ 'hide-down-caret': hideDownCaret }"
              v-if="isExpand"
              @click="expand()"/>
          </p>
        </div>
      </div>
    </div>
  </div>
  <div
    class="description"
    v-else>
    <p>
      Please select a course to display
    </p>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import Tags from 'components/plan/tags'
import axios from 'axios'
import lodash from 'lodash/isEmpty'
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'

export default {
  components: {
    FontAwesomeIcon,
    Tags
  },
  data () {
    return {
      tag: '',
      editableAnnotations: false,
      editableAnnotationsText: '',
      editableText: '',
      annotationTags: [],
      isExpand: false,
      hideDownCaret: false,
      maxLength: 500,
      editableTextlength: 0,
      isPresent: false
    }
  },
  computed: {
    ...mapState('user', {
      course: 'currentCourse'
    })
  },
  watch: {
    course () {
      this.fetchAnnotation()
      this.isPresent = !lodash(this.course)
      if (this.isPresent) {
        this.isExpand = false
        this.editableAnnotation = false
        this.hideDownCaret = false
        this.editableText = false
      }
    },
    editableText (newStr) {
      this.editableTextlength = newStr.length
    }
  },
  methods: {
    OpenAnnotationsForm () {
      if (this.isExpand) {
        this.editableAnnotations = !this.editableAnnotations
        this.hideDownCaret = !this.hideDownCaret
        this.editableText = this.editableAnnotationsText
      }
    },
    expand () {
      this.isExpand = !this.isExpand
    },
    updateAnnotations () {
      axios
        .post('annotations', {course_id: this.course.id, annotation: this.editableText}).then((response) => {
          this.editableAnnotationsText = response.data.annotation
          this.editableAnnotations = !this.editableAnnotations
          this.hideDownCaret = !this.hideDownCaret
        })
    },
    cancelAnnotations () {
      this.annotationTags = []
      this.editableText = ''
      this.editableAnnotations = !this.editableAnnotations
      this.hideDownCaret = !this.hideDownCaret
    },
    fetchAnnotation () {
      axios
        .get('/annotations/get_annotations?course_id=' + this.course.id).then((response) => {
          if (response.data) {
            this.editableAnnotationsText = response.data.annotation
          } else {
            this.editableAnnotationsText = ''
          }
          this.editableText = this.editableAnnotationsText
        })
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
    font-size: 20px;
    color: #0030FF;
  }
  .annotation-border {
    border: 1px solid #000;
    padding: 0 20px;
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
    margin-top: 10px;
  }
  .annotation-border p:nth-child(2){
    margin-bottom: 0px;
  }
  .annotations-up-arrow i, .annotations-down-arrow i {
    font-size: 30px;
    cursor: pointer;
  }
  .annotations-down-arrow {
    text-align: center;
  }
  .annotations-margin-top {
    margin-top: 10px;
  }
  .tags{
    display: inline-block;
    width: 100%;
    text-align: center;
    margin: 20px 0;
  }
  .save-btn button{
    background-color: inherit;
    border: 2px solid #000;
    border-radius: 5px;
    padding: 5px 20px;
    margin-top: 20px;
    margin-bottom: 20px;
    cursor: pointer;
  }
  .hide-down-caret{
    display: none;
  }
  .annotations textarea{
    resize: none !important;
  }
  .word-count{
    position: relative;
    color: gray;
    bottom: 25px;
    left: 100px;
    font-size: 10px;
  }
  .edit-annotation{
    cursor: pointer;
  }
</style>
