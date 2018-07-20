<template>
  <div class="mt-4">
    <p class="heading">Tags</p>

    <input
      v-model="tag"
      class="input-tag text-white w-100 p-2"
      placeholder="Enter a tag"
      @keyup.enter="addActiveTag()">

    <span
      v-for="(tag, index) of activeTags"
      :key="tag.id"
      class="active-tag mt-3 mr-2"
      @click="deactivateTag(index, tag.name)">
      {{ tag.name }}&nbsp;&nbsp;<font-awesome-icon icon="times"/>
    </span>
  </div>
</template>

<script>
import axios from 'axios'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

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
.active-tag {
  cursor: pointer;
  padding: 5px 10px;
  display: inline-block;
  color: black;
  background-color: white;
  font-size: 12px;

  &:hover {
    background-color: #eee;
  }
}

.input-tag {
  background-color: #555;
  border: none;
  font-size: 12px;
}

::placeholder {
  color: white;
}

p.heading {
  border-bottom: 1px solid #999;
  font-size: 12px;
  margin-bottom: 8px;
}
</style>
