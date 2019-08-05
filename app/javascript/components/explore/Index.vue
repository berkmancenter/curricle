<template>
  <div>
    <visualization-card
      title="Keyword Comparisons"
      text="Visualize descriptive terms across the curriculum through keyword comparisons."
      link="/explore/keyword-comparisons"
      image="/images/explore/keywords.png"
    />

    <visualization-card
      title="Learning Styles"
      text="Explore courses by selecting class learning styles and departments."
      link="/explore/learning-styles"
      image="/images/explore/departments.png"
    />

    <visualization-card
      title="Instructor Networks"
      text="Select an instructor to discover faculty networks by course and department."
      link="/explore/instructor-networks"
      image="/images/explore/instructors.png"
    />

    <visualization-card
      title="Course Universe"
      text="Explore all of Harvard's departments and programs to browse their offerings."
      link="/explore/course-universe"
      image="/images/explore/universe.png"
    />
  </div>
</template>

<script>
import VisualizationCard from './IndexVisualizationCard'

export default {
  components: {
    VisualizationCard
  }
}
</script>
