<template>
  <span
    :class="keywordClass"
    :key="keywordIdx"
    :id="kwId"
  >
    <span
      :id="kwId+'-applyTo'"
      class="applyTo"
    >
      {{ keywordApplyTo }}
    </span>
    <span
      :id="kwId+'-weight'"
      :class="'wt-' + selectedWeight"
    >
      {{ selectedWeight }}
    </span>
    <span
    @click="bodyClick">
      {{ keyword.text }}
    </span>&nbsp;&nbsp;
    <font-awesome-icon
      icon="times"
      @click="closeClick"/>
    <b-popover
      v-show="keyword.active"
      :target="kwId"
      triggers="click blur"
      placement="bottom">
      <b-form-input
      v-model="keyword.text"/>
      <b-form-group
        label="Apply To"
      >
        <b-form-checkbox-group
          stacked
          v-model="selected"
          name="search-fields"
          :options="applyToOptions"
          :target="kwId+'-weight'"
          triggers="click blur"
          placement="bottom"
        />
      </b-form-group>
      <b-form-group
      label="Weight">
        <b-form-checkbox-group
          stacked
          v-model="selectedWeight"
          name="search-fields-weight"
          :options="weightOptions"
        />
      </b-form-group>
    </b-popover>
  </span>
</template>

<script>
import { mapState } from 'vuex'
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'
import _ from 'lodash'

export default {
  components: {
    FontAwesomeIcon
  },
  props: {
    keyword: {
      type: Object,
      required: true
    },
    keywordIdx: {
      type: Number,
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
    ...mapState('search', ['applyToOptions', 'weightOptions']),
    keywordClass () {
      return (this.keyword.active ? 'active' : 'inactive') + '-keyword border border-dark rounded'
    },
    kwId () {
      return 'keyword-elem-' + this.keywordIdx
    },
    keywordApplyTo () {
      if (this.selected.length === this.applyToOptions.length - _.filter(this.applyToOptions, { 'disabled': true }).length) {
        return 'a'
      }
      if (this.selected.length === 1) {
        return this.selected[0].charAt(0).toLowerCase()
      }
      return '*'
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

  .applyTo, .wt {
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

.applyTo {
  background-color: black;
  color: white;
}
</style>
