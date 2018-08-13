<template>
  <div class="mt-4">
    <p class="heading">Annotations</p>

    <div>
      <textarea
        v-model="editableText"
        :maxlength="maxLength"
        rows="5"
        class="w-100"/>

      <span class="word-count">{{ editableTextLength }} / {{ maxLength }} characters</span>

      <div class="button-container">
        <button
          class="btn clearfix"
          @click="updateAnnotations">
          Save
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import ANNOTATION_SET_MUTATION from '../../graphql/AnnotationSet.gql'
import COURSE_FRAGMENT from '../../graphql/CourseFragment.gql'

export default {
  components: {
    FontAwesomeIcon
  },
  props: {
    courseId: {
      type: String,
      required: true
    }
  },
  data () {
    return {
      editableText: '',
      maxLength: 500,
      editableTextLength: 0
    }
  },
  computed: {
    course () {
      return this.$apolloProvider.defaultClient.cache.readFragment({
        id: `Course:${this.courseId}`,
        fragment: COURSE_FRAGMENT
      })
    },
    savedAnnotation () {
      return this.course.annotation ? this.course.annotation.text : ''
    }
  },
  watch: {
    editableText (newStr) {
      this.editableTextLength = newStr.length
    },
    savedAnnotation () {
      this.editableText = this.savedAnnotation
    },
    course () {
      this.editableText = this.savedAnnotation
    }
  },
  mounted () {
    this.editableText = this.savedAnnotation
  },
  methods: {
    updateAnnotations () {
      this.$apollo.mutate({
        mutation: ANNOTATION_SET_MUTATION,
        variables: {
          text: this.editableText,
          course_id: this.course.id,
          id: this.course.annotation && this.course.annotation.id
        },
        update: (store, { data: { annotationSet } }) => {
          const localCourse = store.readFragment({
            id: `Course:${this.courseId}`,
            fragment: COURSE_FRAGMENT
          })

          localCourse.annotation = annotationSet

          store.writeFragment({
            id: `Course:${this.courseId}`,
            fragment: COURSE_FRAGMENT,
            data: localCourse
          })
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
  .annotations textarea{
    resize: none !important;
  }

  .word-count {
    position: relative;
    color: #ccc;
    bottom: 30px;
    left: 5px;
    font-size: 10px;
  }

  .pointer {
    cursor: pointer;
  }

  .button-container {
    margin-top: -15px;
  }

  p.heading {
    border-bottom: 1px solid #999;
    font-size: 12px;
    margin-bottom: 8px;
  }

  textarea {
    background-color: #555;
    border: none;
    color: white;
    font-size: 12px;
  }

  button.btn {
    background-color: white;
    color: black;

    &:hover {
      background-color: #ccc;
    }
  }
</style>
