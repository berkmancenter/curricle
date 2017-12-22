<template>
  <div
    class="row"
    v-if="inactiveKeywords.length > 0">
    <div class="col-md-12">
      <b-alert
        show
        variant="secondary">
        <span class="inactive">Inactive</span>
        <span
          class="inactive-keyword border border-dark rounded"
          v-for="(keyword, index) of inactiveKeywords"
          @click="removeKeyword(index)">
          {{ keyword }}&nbsp;&nbsp;<font-awesome-icon icon="times"/>
        </span>
      </b-alert>
    </div>
  </div>
</template>

<script>
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'

export default {
  components: {
    FontAwesomeIcon
  },
  props: {
    inactiveKeywords: {
      type: Array,
      default: function () {
        return []
      }
    }
  },
  methods: {
    removeKeyword (index) {
      this.$emit('removeKeyword', index)
    }
  }
}
</script>

<style lang="scss" scoped>
.inactive {
  color: #777;
  margin-right: 15px;
}
.inactive-keyword {
  cursor: pointer;
  margin-right: 10px;
  padding: 5px 10px;

  &:hover {
    background-color: #eee;
  }
}
</style>
