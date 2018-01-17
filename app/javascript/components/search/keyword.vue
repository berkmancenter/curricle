<template>
  <span
    :class="keywordClass"
    :key="keyword.text"
    @click="keywordClick">
    <span>{{ keyword.applyTo }}</span>
    <span :class="'wt-' + keyword.weight">{{ keyword.weight }}</span>
    {{ keyword.text }}&nbsp;&nbsp;<font-awesome-icon icon="times"/>
  </span>
</template>

<script>
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'

export default {
  components: {
    FontAwesomeIcon
  },
  props: {
    keyword: {
      type: Object,
      required: true
    }
  },
  computed: {
    keywordClass () {
      return (this.keyword.active ? 'active' : 'inactive') + '-keyword border border-dark rounded'
    }
  },
  methods: {
    keywordClick () {
      var act = this.keyword.active ? 'search/deactivateKeyword' : 'search/removeKeyword'
      this.$store.dispatch(act, this.keyword)
    }
  }
}
</script>

<style lang="scss" scoped>
.inactive-keyword, .active-keyword {
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
