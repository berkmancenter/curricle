import _ from 'lodash'
import * as d3 from 'd3'
import apolloClient from 'apollo'
import COURSE_COUNTS_QUERY from '../../graphql/CourseCounts.gql'
import DEPT_COURSES_QUERY from '../../graphql/DeptCourses.gql'
import { transformSchedule } from 'lib/util'

var colorLeft = '#f0cf61'
var colorRight = '#32b67a'
var colorMix = '#005397'

var documentWidth, margin, width, height, courseTypeBarScale, departmentBarScale, courseTypeAxis, departmentAxis

var courseTypeSvg, departmentSvg, classSvg

var courseTypeTextScale = d3.scaleLinear()
  .range([14, 14])

var departmentTextScale = d3.scaleLinear()
  .range([14, 14])

var departmentTextScaleMax, nestedCourseTypeDataMax, courseTypeGradient, departmentGradient

var fullData

let courseIdInTray
let selectCourse
let semester
let showLoaderOverlay

const fontSize = '12px'

function initSetup (selectCourseFunction, selectedSemester, showLoaderOverlayFunction, courseIdInTrayFunction) {
  courseIdInTray = courseIdInTrayFunction
  selectCourse = selectCourseFunction
  semester = selectedSemester
  showLoaderOverlay = showLoaderOverlayFunction
  documentWidth = d3.select('#visContainer').node().getBoundingClientRect().width

  // remove existing SVGs prior to (re)drawing new ones
  d3.select('#visContainer').selectAll('svg').remove()

  const marginX = 1
  margin = { top: 40, right: marginX, bottom: 10, left: marginX }
  width = documentWidth / 2 - margin.left - margin.right
  height = 100 - margin.top - margin.bottom
  courseTypeBarScale = d3.scaleLinear()
    .range([width, 0])
  departmentBarScale = d3.scaleLinear()
    .range([0, width])
  courseTypeAxis = d3.axisTop(courseTypeBarScale).ticks(5)
  departmentAxis = d3.axisTop(departmentBarScale).ticks(5)
  courseTypeSvg = d3.select('#courseTypeVis').append('svg')
    .attr('width', width + margin.left + margin.right)
    .attr('height', height + margin.top + margin.bottom)
    .append('g')
    .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

  departmentSvg = d3.select('#departmentVis').append('svg')
    .attr('width', width + margin.left + margin.right)
    .attr('height', height + margin.top + margin.bottom)
    .append('g')
    .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

  classSvg = d3.select('#classVis').append('svg')
    .attr('width', width * 2)
    .attr('height', 0)
    .append('g')
    .attr('transform', 'translate(' + 0 + ',' + 40 + ')')

  courseTypeGradient = courseTypeSvg.append('defs')
    .append('linearGradient')
    .attr('id', 'courseTypeGradient')

  courseTypeGradient.append('stop')
    .attr('stop-color', '#fff')
    .attr('offset', '0')

  courseTypeGradient.append('stop')
    .attr('stop-color', colorLeft)
    .attr('offset', '1')

  departmentGradient = departmentSvg.append('defs')
    .append('linearGradient')
    .attr('id', 'departmentGradient')

  departmentGradient.append('stop')
    .attr('stop-color', colorRight)
    .attr('offset', '0')

  departmentGradient.append('stop')
    .attr('stop-color', '#fff')
    .attr('offset', '1')

  loadFullData(semester)

  document.getElementById('departmentHeadline').onclick = function () { setCourseTypeData(fullData, true) }
  document.getElementById('courseTypeHeadline').onclick = function () { setDepartmentData(fullData, true) }

  window.addEventListener('resize', resizing)
}

function loadFullData (semester) {
  showLoaderOverlay(true)

  apolloClient.query({
    query: COURSE_COUNTS_QUERY,
    variables: { semester }
  }).then(function (response) {
    fullData = response.data.course_counts
    appendAxis()
    setDepartmentData(response.data.course_counts)
    setCourseTypeData(response.data.course_counts)
    showLoaderOverlay(false)
  })
}

function appendAxis () {
  departmentSvg.append('g')
    .attr('class', 'axis departmentAxis')
    .attr('transform', 'translate(-1,-15)')
    .call(departmentAxis)
    .style('opacity', 0)
    .transition()
    .duration(1000)
    .style('opacity', 1)

  courseTypeSvg.append('g')
    .attr('class', 'axis courseTypeAxis')
    .attr('transform', 'translate(1,-15)')
    .call(courseTypeAxis)
    .style('opacity', 0)
    .transition()
    .duration(1000)
    .style('opacity', 1)

  d3.selectAll('.domain')
    .style('display', 'none')
}

function setDepartmentData (data) {
  var nestedDepartmentData = d3.nest()
    .key(function (d) { return d.department })
    .rollup(function (v) {
      return {
        count: d3.sum(v, function (d) { return d.count })
      }
    })
    .entries(data)

  d3.select('#departmentVis')
    .select('svg')
    .transition()
    .delay(500)
    .duration(1000)
    .attr('height', nestedDepartmentData.length * 20 + 22)

  const sortedDepartmentData = _.sortBy(nestedDepartmentData, 'key')

  departmentTextScaleMax = d3.max(sortedDepartmentData, function (d) { return d.value.count })

  departmentTextScale.domain([0, departmentTextScaleMax])
  departmentBarScale.domain([0, departmentTextScaleMax])

  departmentSvg.select('.axis').transition(1000).call(departmentAxis)

  setDepartmentVis(sortedDepartmentData)
}

function setCourseTypeData (data, expand) {
  var nestedCourseTypeData = d3.nest()
    .key(function (d) { return d.component })
    .rollup(function (v) {
      return {
        count: d3.sum(v, function (d) { return d.count })
      }
    })
    .entries(data)

  if (expand) {
    d3.select('#courseTypeVis')
      .select('svg')
      .transition()
      .attr('height', nestedCourseTypeData.length * 20 + 22)
  } else {
    d3.select('#courseTypeVis')
      .select('svg')
      .transition()
      .delay(500)
      .duration(1000)
      .attr('height', nestedCourseTypeData.length * 20 + 22)
  }

  nestedCourseTypeData.sort(function (a, b) {
    return b.value.count - a.value.count
  })

  nestedCourseTypeDataMax = d3.max(nestedCourseTypeData, function (d) { return d.value.count })

  courseTypeTextScale.domain([0, nestedCourseTypeDataMax])
  courseTypeBarScale.domain([0, nestedCourseTypeDataMax])

  courseTypeSvg.select('.axis').transition(1000).call(courseTypeAxis)

  setCourseTypeVis(nestedCourseTypeData)
}

function setCourseTypeVis (data) {
  var courseTypeRect = courseTypeSvg.selectAll('.courseTypeRect')
    .data(data, function (d) { return d.key })

  courseTypeRect.exit().remove()

  courseTypeRect.transition().duration(500)
    .attr('transform', function (d, i) {
      return 'translate(' + (courseTypeBarScale(d.value.count)) + ',' + (i * 20 - 15) + ')'
    })
    .attr('width', function (d, i) { return width - courseTypeBarScale(d.value.count) })
    .style('fill', 'url(#courseTypeGradient)')

  courseTypeRect
    .enter()
    .append('rect')
    .attr('class', function (d) { return 'courseTypeRect ' + d.key })
    .attr('transform', function (d, i) {
      return 'translate(' + (courseTypeBarScale(d.value.count)) + ',' + (i * 20 - 15) + ')'
    })
    .attr('width', function (d, i) { return width - courseTypeBarScale(d.value.count) })
    .attr('height', 18)
    .style('opacity', 0)
    .style('fill', 'url(#courseTypeGradient)')
    .on('click', dataFilter)
    .transition()
    .delay(500)
    .duration(500)
    .style('opacity', 1)

  var courseTypeText = courseTypeSvg.selectAll('.courseTypeText')
    .data(data, function (d) { return d.key })

  courseTypeText.exit().remove()

  courseTypeText.transition().duration(500)
    .style('font-size', fontSize)
    .attr('transform', function (d, i) {
      return 'translate(' + (width - 5) + ',' + (i * 20) + ')'
    })

  courseTypeText
    .enter()
    .append('text')
    .attr('class', function (d) { return 'courseTypeText ' + d.key })
    .attr('transform', function (d, i) {
      return 'translate(' + (width - 5) + ',' + (i * 20) + ')'
    })
    .style('text-anchor', 'end')
    .style('opacity', 0)
    .style('font-size', fontSize)
    .text(function (d) { return d.key })
    .on('click', dataFilter)
    .transition()
    .delay(500)
    .duration(500)
    .style('opacity', 1)
}

function setDepartmentVis (data) {
  var departmentRect = departmentSvg.selectAll('.departmentRect')
    .data(data, function (d) { return d.key })

  departmentRect.exit().remove()

  departmentRect.transition().duration(500)
    .attr('transform', function (d, i) {
      return 'translate(' + (0) + ',' + (i * 20 - 15) + ')'
    })
    .style('fill', 'url(#departmentGradient)')
    .attr('width', function (d, i) { return departmentBarScale(d.value.count) })

  departmentRect
    .enter()
    .append('rect')
    .attr('class', function (d) { return 'departmentRect ' + d.key })
    .attr('transform', function (d, i) {
      return 'translate(' + (0) + ',' + (i * 20 - 15) + ')'
    })
    .attr('width', function (d, i) { return departmentBarScale(d.value.count) })
    .attr('height', 18)
    .style('opacity', 0)
    .style('fill', 'url(#departmentGradient)')
    .on('click', dataFilter)
    .transition()
    .delay(500)
    .duration(500)
    .style('opacity', 1)

  var departmentText = departmentSvg.selectAll('.departmentText')
    .data(data, function (d) { return d.key })

  departmentText.exit().remove()

  departmentText.transition().duration(500)
    .style('font-size', fontSize)
    .attr('transform', function (d, i) {
      return 'translate(' + 5 + ',' + (i * 20) + ')'
    })

  departmentText
    .enter()
    .append('text')
    .attr('class', function (d) { return 'departmentText ' + d.key })
    .attr('transform', function (d, i) { return 'translate(' + 5 + ',' + (i * 20) + ')' })
    .style('text-anchor', 'start')
    .style('opacity', 0)
    .style('font-size', fontSize)
    .text(function (d) { return d.key })
    .on('click', dataFilter)
    .transition()
    .delay(500)
    .duration(500)
    .style('opacity', 1)
}

var filterDatumDepartment
var filterDatumCourseType
var filteredData

function dataFilter () {
  if (this.classList[0] === 'departmentText' || this.classList[0] === 'departmentRect') {
    if (filterDatumDepartment === this.__data__.key) {
      filterDatumDepartment = undefined
      d3.select(this).style('fill', 'black')
    } else {
      filterDatumDepartment = this.__data__.key
      d3.selectAll('.departmentText').style('fill', 'black')
      d3.selectAll('.departmentRect').style('fill', 'url(#departmentGradient)')
      d3.select(this).style('fill', colorMix)
    }
  } else if (this.classList[0] === 'courseTypeText' || this.classList[0] === 'courseTypeRect') {
    if (filterDatumCourseType === this.__data__.key) {
      filterDatumCourseType = undefined
      d3.select(this).style('fill', 'black')
    } else {
      filterDatumCourseType = this.__data__.key
      d3.selectAll('.courseTypeText').style('fill', 'black')
      d3.selectAll('.courseTypeRect').style('fill', 'url(#courseTypeGradient)')
      d3.select(this).style('fill', colorMix)
    }
  }

  if (typeof filterDatumDepartment !== 'undefined' && typeof filterDatumCourseType !== 'undefined') {
    filteredData = fullData.filter(function (d) { return d.component === filterDatumCourseType && d.department === filterDatumDepartment })
    setCourseTypeData(filteredData)
    setDepartmentData(filteredData)
    loadClassData(filteredData)
  } else if (typeof filterDatumDepartment === 'undefined' && typeof filterDatumCourseType === 'string') {
    classSvg.selectAll('.classText').remove()
    filteredData = fullData.filter(function (d) { return d.component === filterDatumCourseType })
    setDepartmentData(filteredData, true)
  } else if (typeof filterDatumCourseType === 'undefined' && typeof filterDatumDepartment === 'string') {
    classSvg.selectAll('.classText').remove()
    filteredData = fullData.filter(function (d) { return d.department === filterDatumDepartment })
    setCourseTypeData(filteredData, true)
  } else {
    setCourseTypeData(fullData, true)
    setDepartmentData(fullData, true)
  }
}

function resizing () {
  const containerWidth = d3.select('#visContainer').node().getBoundingClientRect().width

  if (documentWidth !== containerWidth) {
    documentWidth = containerWidth
    width = documentWidth / 2 - margin.left - margin.right

    d3.select('#departmentVis')
      .select('svg')
      .transition()
      .attr('width', width)

    d3.select('#courseTypeVis')
      .select('svg')
      .transition()
      .attr('width', width)

    courseTypeBarScale.range([width, 0])
    departmentBarScale.range([0, width])

    courseTypeSvg.select('.axis').transition(1000).call(courseTypeAxis)
    departmentSvg.select('.axis').transition(1000).call(departmentAxis)

    d3.selectAll('.departmentRect').transition().duration(500)
      .attr('width', function (d, i) { return departmentBarScale(d.value.count) })

    d3.selectAll('.courseTypeRect').transition().duration(500)
      .attr('transform', function (d, i) {
        return 'translate(' + (courseTypeBarScale(d.value.count)) + ',' + (i * 20 - 15) + ')'
      })
      .attr('width', function (d, i) { return width - courseTypeBarScale(d.value.count) })

    d3.selectAll('.courseTypeText').transition().duration(500)
      .attr('transform', function (d, i) {
        return 'translate(' + (width - 5) + ',' + (i * 20) + ')'
      })
  }
}

function loadClassData (data) {
  const semesterRange = { start: semester }
  var searchComponent = data[0].component.toUpperCase().replace(/\s/g, '_').replace(/\s/g, '_').replace(/[`~!@#$%^&*()|+\-=?:'",.<>{}[\]\\/]/gi, '')
  var searchDepartment = data[0].department.toUpperCase().replace(/\s/g, '_').replace(/\s/g, '_').replace(/[`~!@#$%^&*()|+\-=?:'",.<>{}[\]\\/]/gi, '')

  showLoaderOverlay(true)

  apolloClient.query({
    query: DEPT_COURSES_QUERY,
    variables: {
      semesterRange, searchDepartment, searchComponent
    }
  })
    .then(function (response) {
      const courses = response.data.coursesConnection.edges.map(course => course.node)
      classVisualization(courses)
      showLoaderOverlay(false)
    })
}

function classVisualization (data) {
  d3.select('#classVis')
    .select('svg')
    .transition()
    .attr('height', data.length * 20 + 100)

  var classText = classSvg.selectAll('.classText')
    .data(data)

  classText
    .enter()
    .append('text')
    .attr('class', function (d) { return courseIdInTray(d.id) ? 'tray-course classText' : 'classText' })
    .attr('transform', function (d, i) {
      return 'translate(' + (width - width / 3) + ',' + (i * 20) + ')'
    })
    .style('text-anchor', 'left')
    .style('opacity', 0)
    .style('font-size', fontSize)
    .text(function (d) { return d.title })
    .on('click', courseClick)
    .transition()
    .delay(500)
    .duration(500)
    .style('opacity', 1)
}

function courseClick () {
  const course = _.clone(this.__data__)

  course.schedule = transformSchedule(course)

  selectCourse(course)
}

export { initSetup }
