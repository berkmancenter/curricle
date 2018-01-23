<template>
  <span>
    <i
      :class="{ fa: true, 'fa-list-ul': true, active: viewmode =='list-view'}"
      @click="selectView('list-view')"
    />
    <i
      :class="{ fa: true, 'fa-calendar': true, active: viewmode =='semester'} "
      @click="selectView('semester')"
    />
    <i
      :class="{ fa: true, 'fa-square': true, active: viewmode == 'multi-year' }"
      @click="selectView('multi-year')"
    />
  </span>
</template>

<script>
import { mapActions, mapState } from 'vuex'

export default {
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
