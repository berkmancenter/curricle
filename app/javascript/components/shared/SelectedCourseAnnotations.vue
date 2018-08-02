<template>
  <div class="mt-4">
    <p class="heading">Annotations</p>

    <div>
      <textarea
        v-model="editableText"
        rows="5"
        class="w-100"
        maxlength="500"/>

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

export default {
  components: {
    FontAwesomeIcon
  },
  props: {
    course: {
      type: Object,
      required: true
    }
  },
  data () {
    return {
      editableAnnotationText: '',
      editableText: '',
      maxLength: 500,
      editableTextLength: 0,
      updatedAnnotationText: {}
    }
  },
  computed: {
    savedAnnotation () {
      if (this.updatedAnnotationText[this.course.id]) {
        return this.updatedAnnotationText[this.course.id]
      }

      if (!this.course.annotation) {
        return ''
      }

      return this.course.annotation.text
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
      this.$apollo.provider.defaultClient.mutate({
        mutation: ANNOTATION_SET_MUTATION,
        variables: {
          text: this.editableText,
          course_id: this.course.id,
          id: this.course.annotation && this.course.annotation.id
        }
      }).then(response => {
        this.updatedAnnotationText[this.course.id] = response.data.annotationSet.text
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
