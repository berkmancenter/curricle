<template>
  <div class="row">
    <div class="col-md-12">
      <span
        class="active-keyword border border-dark rounded"
        v-for="(keyword, index) of activeKeywords"
        @click="deactivateKeyword(index)">
        {{ keyword }}&nbsp;&nbsp;<font-awesome-icon icon="times"/>
      </span>
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
    activeKeywords: {
      type: Array,
      default: function () {
        return []
      }
    }
  },
  methods: {
    deactivateKeyword (index) {
      this.$emit('deactivateKeyword', index)
    }
  }
}
</script>

<style lang="scss" scoped>
.active-keyword {
  cursor: pointer;
  margin-right: 10px;
  padding: 5px 10px;

  &:hover {
    background-color: #eee;
  }
}
</style>
