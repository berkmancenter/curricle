<template>
  <span
    :class="keywordClass"
    :key="keyword.text"
    :id="kwId"
  >
    <span @click="applyToClick" :id="kwId+'-applyTo'">{{ keywordApplyTo }}</span>
    <span :class="'wt-' + keyword.weight" :id="kwId+'-weight'" @click="weightClick">{{ keyword.weight }}</span>
    <span @click="bodyClick"> {{ keyword.text }} </span>&nbsp;&nbsp;<font-awesome-icon icon="times" @click="closeClick"/>
    <b-popover
      :target="kwId+'-applyTo'"
      triggers="click blur"
      placement="bottom">
      <b-form-checkbox-group
        stacked
        v-model="selected"
        name="search-fields"
        :options="options"
      />
    </b-popover>
    <b-popover
      :target="kwId+'-weight'"
      triggers="click blur"
      placement="bottom">
      <b-form-checkbox-group
        stacked
        v-model="selectedWeight"
        name="search-fields-weight"
        :options="weightOptions"
      />
    </b-popover>
  </span>
</template>

<script>
import { mapState } from 'vuex'
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
  data () {
    return {
      selected: this.keyword.applyTo,
      selectedWeight: this.keyword.weight
    }
  },
  computed: {
    ...mapState('search', { options: 'applyToOptions', weightOptions: 'weightOptions'}),
    keywordClass () {
      return (this.keyword.active ? 'active' : 'inactive') + '-keyword border border-dark rounded'
    },
    kwId () {
      return 'keyword-elem-' + this.keyword.text
    },
    keywordApplyTo () {
      return this.selected
    }
  },
  methods: {
    closeClick () {
      var act = this.keyword.active ? 'search/deactivateKeyword' : 'search/removeKeyword'
      this.$store.dispatch(act, this.keyword)
    },
    bodyClick () {
      if (!this.keyword.active) {
        this.$store.dispatch('search/activateKeyword', this.keyword)
      }
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
