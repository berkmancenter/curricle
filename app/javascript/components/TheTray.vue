<template>
  <div id="tray">
    <div
      v-show="trayVisible"
      class="pt-3 px-3"
    >
      <div class="your-tray-parent clearfix">
        <p>
          Schedule

          <span class="float-right">
            <font-awesome-icon
              class="pointer ml-2"
              icon="times"
              @click="trayClose"
            />
          </span>
        </p>
      </div>

      <tray-list />

      <b-button
        class="w-100 mt-4"
        variant="light"
        to="/plan/week"
      >
        Go to Week View
      </b-button>

      <share-link
        class="mt-2"
      />
    </div>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import ShareLink from 'components/tray/TrayShareLink'
import TrayList from 'components/tray/TrayList'

export default {
  components: {
    FontAwesomeIcon,
    ShareLink,
    TrayList
  },
  computed: {
    ...mapState('app', ['trayVisible'])
  },
  methods: {
    ...mapActions('app', ['trayClose'])
  }
}
</script>
