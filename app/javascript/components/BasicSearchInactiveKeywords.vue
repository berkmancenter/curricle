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
          :key="keyword.text"
          @click="removeKeyword(index)">
          <span>{{ keyword.applyTo }}</span> <span :class="'wt-' + keyword.weight">{{ keyword.weight }}</span> {{ keyword.text }}&nbsp;&nbsp;<font-awesome-icon icon="times"/>
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
  display: inline-block;
  margin: 0 10px 10px 0;
  padding: 5px 10px;

  &:hover {
    background-color: #eee;
  }

  .wt {
    display: inline;
    width: 1em;
    height: 1em;
    font-size: .75em;
    padding: 2px;
  }
  $weights: 1,2,3,4,5,6,7,8,9,10;

  @each $k in $weights {
    .wt-#{$k} {
      @extend .wt;

      @if $k > 5 {
        color: white;
      } @else {
        color: black;
      }

      background-color: rgb(255 - $k * 25, 255 - $k * 25, 255 - $k * 25);
    }
  }
}
</style>
