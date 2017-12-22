<template>
  <div
    class="row curricle-search-result"
    :style="borderStyle">
    <div class="col-md-2">
      <strong>
        {{ academic_group }}
        <br>
        {{ subject }} {{ catalog_number }}
        <br>
        {{ term_name }} {{ term_year }}
        <br>
        {{ units_maximum }} Units
      </strong>
    </div>
    <div class="col-md-2">
      Component: <strong>{{ component }}</strong>
      <br>
      Grading Basis:
      <br>
      Instructor:
    </div>
    <div class="col-md-6">
      <h5>{{ title }}</h5>
      <span v-html="description"/>
    </div>
    <div class="col-md-2">
      Schedule
    </div>
  </div>
</template>

<script>
export default {
  props: {
    academic_group: {
      type: String,
      required: true
    },
    catalog_number: {
      type: Number,
      required: true
    },
    component: {
      default: '',
      type: String
    },
    description: {
      type: String,
      required: true
    },
    id: {
      type: Number,
      required: true
    },
    subject: {
      type: String,
      required: true
    },
    term_name: {
      type: String,
      required: true
    },
    term_year: {
      type: Number,
      required: true
    },
    title: {
      type: String,
      required: true
    },
    units_maximum: {
      type: Number,
      required: true
    }
  },
  computed: {
    borderStyle () {
      // TODO: map course color to data
      const randomColor = Math.floor((Math.random() * (999 - 599)) + 600)

      return {
        'border-left-color': ('#' + randomColor)
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.curricle-search-result {
  font-size: 13px;
  border-left-width: 10px;
  border-left-style: solid;
  border-top: 1px solid #ccc;
  margin-left: 0;
  padding-top: 10px;

  h5 {
    font-size: 16px;
  }
}
</style>
