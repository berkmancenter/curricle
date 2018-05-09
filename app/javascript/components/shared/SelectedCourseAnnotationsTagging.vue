<template>
  <div class="row">
    <div class="col-md-12">
      <span
        v-for="(tag, index) of activeTags"
        :key="tag.id"
        class="active-keyword border border-dark rounded"
        @click="deactivateTag(index, tag.name)">
        {{ tag.name }}&nbsp;&nbsp;<font-awesome-icon icon="times"/>
      </span>
      <input
        v-model="tag"
        class="input-tag"
        placeholder="Enter Tag"
        @keyup.enter="addActiveTag()">
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'

export default {
  components: {
    FontAwesomeIcon
  },
  props: {
    courseId: {
      type: String,
      required: true
    },
    activeTags: {
      type: Array,
      default: function () {
        return []
      }
    }
  },
  data: function () {
    return { tag: '' }
  },
  methods: {
    deactivateTag (index, tagName) {
      axios.delete('/tags/remove', { data: {
        course_id: this.courseId,
        name: tagName
      }})
        .then(function (response) {
          console.log(response)
        })
        .catch(function (error) {
          console.log(error)
        })
      this.activeTags.splice(index, 1)
    },
    addActiveTag () {
      if (this.tag) {
        axios.post('/tags', {
          course_id: this.courseId,
          name: this.tag
        })
          .then(function (response) {
            console.log(response.data)
          })
          .catch(function (error) {
            console.log(error)
          })
        this.activeTags.push({name: this.tag, course_id: this.courseId})
        this.tag = ''
      }
    }
  }
}
</script>

<style scoped lang="scss">
.active-keyword {
  cursor: pointer;
  margin: 5px 5px 0px 0px;
  padding: 5px 10px;
  display: inline-block;
  border: 2px solid !important;

  &:hover {
    background-color: #eee;
  }
}

.input-tag {
  margin: 5px 0px;
  border: none;
}
</style>
