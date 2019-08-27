<template>
  <div>
    <visualization-card
      title="Keyword Comparisons"
      text="Pick two search terms and check out the courses that fall into the area of overlap."
      link="/explore/keyword-comparisons"
      image="/images/explore/keywords.png"
    />

    <visualization-card
      title="Learning Styles"
      text="Browse courses by their format (lab, lecture, seminar, tutorial, and so on)."
      link="/explore/learning-styles"
      image="/images/explore/departments.png"
    />

    <visualization-card
      title="Instructor Networks"
      text="Explore connections among faculty members by their courses and departments."
      link="/explore/instructor-networks"
      image="/images/explore/instructors.png"
    />

    <visualization-card
      title="Course Universe"
      text="Zoom out and survey the entire course catalog; zoom in and look at individual departments and courses."
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
