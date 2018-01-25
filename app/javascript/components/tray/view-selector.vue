<template>
  <span>
    <i
      :class="{ fa: true, 'fa-list-ul': true, active: viewmode[type] == 'list-view'}"
      @click="selectView({ view: 'list-view', type })"
    />
    <i
      :class="{ fa: true, 'fa-calendar': true, active: viewmode[type] == 'semester'} "
      @click="selectView({ view: 'semester', type })"
    />
    <i
      :class="{ fa: true, 'fa-square': true, active: viewmode[type] == 'multi-year'}"
      @click="selectView({ view: 'multi-year', type })"
    />
  </span>
</template>

<script>
import { mapActions, mapState } from 'vuex'

export default {
  props: {
    type: {
      type: String,
      default: 'tray'
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

<style type="text/css">
.actions .fa {
  color: gray;
}

.actions .fa.active {
  color: black;
}
</style>
