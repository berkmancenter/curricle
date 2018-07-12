<template>
  <span
    :class="keywordClass"
    :key="keyword.ident"
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
      ref="popover"
      :target="kwId"
      triggers="click blur"
      placement="bottom"
      @show="popoverShow($event)"
      @hide="popoverHide($event)"
      @shown="popoverActivate($event)">
      <b-form-input
        :id="kwId+'-kw-edit-keyword'"
        v-model="keyword.text"/>
      <b-form-group
        label="Apply To"
      >
        <b-form-checkbox-group
          v-model="selected"
          :options="applyToOptions"
          :target="kwId+'-weight'"
          name="search-fields"
          stacked/>
      </b-form-group>
      <b-form-group
        label="Weight">
        <b-form-checkbox-group
          v-model="selectedWeight"
          :options="weightOptions"
          name="search-fields-weight"
          stacked/>
      </b-form-group>
    </b-popover>
  </span>
</template>

<script>
import { mapState } from 'vuex'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import _ from 'lodash'

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
      selectedWeight: this.keyword.weight,
      editing: false
    }
  },
  computed: {
    ...mapState('search', ['applyToOptions', 'weightOptions']),
    keywordClass () {
      return (this.keyword.active ? 'active' : 'inactive') + '-keyword border border-dark rounded'
    },
    kwId () {
      return 'keyword-elem-' + this.keyword.ident
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
    },
    popoverShow (arg) {
      this.$root.$emit('bv::hide::popover')
      this.editing = true
    },
    popoverHide (arg) {
      this.editing = false
    },
    popoverActivate (arg) {
      var el2 = document.getElementById(this.kwId + '-kw-edit-keyword')
      if (el2) {
        el2.focus()
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
