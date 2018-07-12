<template>
  <p class="float-left">
    <font-awesome-icon
      v-show="showListView"
      :class="{ active: viewmode[type] == 'list-view'}"
      class="mr-2"
      icon="list"
      @click="selectView({ view: 'list-view', type })"
    />
    <font-awesome-icon
      :class="{ active: viewmode[type] == 'semester'} "
      class="mr-2"
      icon="calendar-alt"
      @click="selectView({ view: 'semester', type })"
    />
    <font-awesome-icon
      :class="{ active: viewmode[type] == 'multi-year'}"
      icon="square"
      @click="selectView({ view: 'multi-year', type })"
    />
  </p>
</template>

<script>
import { mapActions, mapState } from 'vuex'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

export default {
  components: {
    FontAwesomeIcon
  },
  props: {
    type: {
      type: String,
      default: 'tray'
    },
    showListView: {
      type: Boolean,
      default: true
    }
  },
  computed: {
    ...mapState('app', ['viewmode'])
  },
  methods: {
    ...mapActions('app', ['selectView'])
  }
}
</script>

<style scoped>
svg {
  color: gray;
}

svg.active {
  color: black;
}
</style>
