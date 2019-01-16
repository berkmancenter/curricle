import _ from 'lodash'
import * as d3 from 'd3'
import apolloClient from 'apollo'
import COURSE_COUNTS_QUERY from '../../graphql/CourseCounts.gql'
import COURSES_SEARCH_QUERY from '../../graphql/CoursesSearch.gql'
import { transformSchedule } from 'lib/util'

let visSize

const windowHeight = window.innerHeight
// main 'container' area is 10 columns wide (out of 12 total) with 5% padding on left/right
const documentWidth = window.innerWidth * 0.8333333 * 0.9
let backgroundGroup
let context
let diameter
let pack
let root
let selectCourse
let semester
let showLoaderOverlay
let tooltipDiv
let svg

if (windowHeight > documentWidth) {
  visSize = documentWidth
} else {
  visSize = windowHeight
}

visSize = Math.min(900, visSize)

var dotSize = visSize / 500

if (dotSize > 2) { dotSize = 2 }

function initSetup (selectCourseFunction, selectedSemester, showLoaderOverlayFunction) {
  semester = selectedSemester
  selectCourse = selectCourseFunction
  showLoaderOverlay = showLoaderOverlayFunction

  var width = +visSize
  var height = +visSize
  diameter = +visSize

  d3.select('#visSVG').selectAll('g').remove()

  svg = d3.select('#visSVG')
  svg.attr('width', width)
  svg.attr('height', height)

  backgroundGroup = svg.append('g').attr('id', 'backgroundGroup')
    .attr('transform', 'translate(' + (diameter / 2) + ',' + (diameter / 2) + ')')
    .style('opacity', 0)

  svg.append('g').attr('id', 'visGroup')
    .attr('transform', 'translate(' + (diameter / 2) + ',' + (diameter / 2) + ')')

  backgroundGroup.append('rect')
    .attr('x', -width)
    .attr('y', -height)
    .attr('width', width * 2)
    .attr('height', height * 2)
    .style('fill', '#fff')

  backgroundGroup.append('text')
    .attr('id', 'backText')
    .attr('x', -diameter / 2 + diameter / 10)
    .attr('y', -diameter / 2 + diameter / 10)
    .text('back')

  const canvas = d3.select('canvas')

  context = canvas.node().getContext('2d')

  canvas.attr('width', visSize)
  canvas.attr('height', visSize)

  pack = d3.pack()
    .size([diameter, diameter])
    .padding(50)

  tooltipDiv = d3.select('#visWrapper').append('div')
    .attr('class', 'universeTooltip')
    .style('opacity', 0)

  requestFirstData()
}

function requestFirstData () {
  showLoaderOverlay(true)

  apolloClient.query({
    query: COURSE_COUNTS_QUERY,
    variables: { semester: semester }
  }).then(function (response) {
    nestData(response.data.course_counts)
    showLoaderOverlay(false)
  })
}

function nestData (data) {
  var nest = d3.nest()
    .key(function (d) { return d.department })
    // .key(function(d) { return d.component; })
    // .rollup(function(d) { return d.count; });
    .rollup(function (d) { return d3.sum(d, function (d) { return d.count }) })

  root = d3.hierarchy({ values: nest.entries(data) }, function (d) { return d.values })
    .sum(function (d) { return d.value })
    .sort(function (a, b) { return b.value - a.value })

  drawVis(root)
}

function drawVis (data) {
  pack(data)

  var node = svg.select('#visGroup')
    .selectAll('g')
    .data(data.descendants())
    .enter().append('g')
    .attr('transform', function (d) { return 'translate(' + (d.x - diameter / 2) + ',' + (d.y - diameter / 2) + ')' })
    .attr('id', function (d, i) {
      d.index = i
      return 'node_' + i
    })
    .attr('class', function (d) { return 'node' + (!d.children ? ' node--leaf' : d.depth ? '' : ' node--root') })

  node.append('circle')
    .attr('id', function (d, i) {
      return 'mainCircle_' + i
    })
    .attr('r', function (d) { return d.r })
    .on('click', function (d) {
      if (focus !== d) {
        zoomIn(d, this.__data__.data.key)
        d3.event.stopPropagation()
      }
    })

  // Create a wrapper for the arcs and text
  var hiddenArcWrapper = node.append('g')
    .attr('class', 'hiddenArcWrapper')
    .style('opacity', 1)
  // Create the arcs on which the text can be plotted - will be hidden
  hiddenArcWrapper.append('path')
    .attr('class', 'circleArcHidden')
    .attr('id', function (d, i) { return 'circleArc_' + i })
    // .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
    .attr('d', function (d, i) {
      const arcR = d.r
      return 'M ' + -arcR + ' 0 A ' + arcR + ' ' + arcR + ' 0 0 1 ' + arcR + ' 0'
    })
    .style('stroke', 'none')
    .style('fill', 'none')

  // Append the text to the arcs
  hiddenArcWrapper
    .append('text')
    .attr('id', function (d, i) { return 'circleText_' + i })
    .attr('class', 'circleText')
    .style('font-size', function (d) {
      d.fontSize = d.r / 3.5
      return Math.round(d.fontSize) + 'px'
    })
    .append('textPath')
    .attr('startOffset', '10%')
    .style('text-anchor', 'start')
    .attr('xlink:href', function (d, i) { return '#circleArc_' + i })
    .text(function (d) {
      if (d.data.key !== undefined) {
        var name = d.data.key
        if (name.length > 25) {
          name = name.substring(0, 24) + '...'
        }
        return name
      }
    })

  drawCanvas(data.children)

  svg.select('#backgroundGroup').on('click', function () {
    zoomOut(root)
  })

  var selectedIndex

  function zoomIn (d, thisKey) {
    selectedIndex = d.index
    node.style('pointer-events', 'none').transition().duration(500).style('opacity', 0)
    backgroundGroup.transition().duration(500).style('opacity', 1)

    //  Load Close-Up View
    requestSecondData(thisKey, d.x, d.y, d.r)
    closeUpVisTypo(selectedIndex)
  }

  function zoomOut (d, thisKey) {
    node.transition().duration(500).style('opacity', 1).style('pointer-events', 'auto')
    backgroundGroup.transition().duration(500).style('opacity', 0)

    //  Load Close-Up View
    removeCloseUpVis()
    closeUpVisTypoClose(selectedIndex)
  }

  function closeUpVisTypo (selectedIndex) {
    svg.select('#node_' + selectedIndex)
      .transition()
      .duration(500)
      .style('opacity', 1)
    // .style("pointer-events", 'auto');

    svg.select('#node_' + selectedIndex)
      .attr('transform', function (d) { return 'translate(' + 0 + ',' + 0 + ')' })

    svg.select('#mainCircle_' + selectedIndex)
      .attr('r', function (d) {
        return (diameter / 2) * 0.8
      })

    svg.select('#circleArc_' + selectedIndex)
      .attr('d', function (d, i) {
        var dK = (diameter / 2) * 0.8
        return 'M ' + -dK + ' 0 A ' + dK + ' ' + dK + ' 0 0 1 ' + dK + ' 0'
      })

    svg.select('#circleText_' + selectedIndex)
      .style('font-size', function (d) {
        d.fontSize = diameter / 20
        return Math.round(d.fontSize) + 'px'
      })
  }

  function closeUpVisTypoClose (selectedIndex) {
    svg.select('#node_' + selectedIndex)
      .transition()
      .duration(500)
      .style('opacity', 1)
      .style('pointer-events', 'auto')

    svg.select('#node_' + selectedIndex)
      // .attr("transform", function(d) { return "translate(" + this.__data__.x + "," + this.__data__.y + ")"; });
      .attr('transform', function (d) { return 'translate(' + (this.__data__.x - diameter / 2) + ',' + (this.__data__.y - diameter / 2) + ')' })

    svg.select('#mainCircle_' + selectedIndex)
      .attr('r', function (d) {
        return this.__data__.r
      })

    svg.select('#circleArc_' + selectedIndex)
      .attr('d', function (d, i) {
        var dK = this.__data__.r
        return 'M ' + -dK + ' 0 A ' + dK + ' ' + dK + ' 0 0 1 ' + dK + ' 0'
      })

    svg.select('#circleText_' + selectedIndex)
      .style('font-size', function (d) {
        d.fontSize = this.__data__.r / 3.5
        return Math.round(d.fontSize) + 'px'
      })
  }
}

function drawCanvas (data) {
  data.forEach(function (d, i) {
    randomPoints(d.x, d.y, d.r, d.value)
  })
}

function randomPoints (xPos, yPos, radius, amount) {
  const randomX = d3.randomNormal(xPos, radius / 4)
  const randomY = d3.randomNormal(yPos, radius / 4)
  const data = d3.range(amount).map(function () { return [randomX(), randomY()] })

  context.fillStyle = '#000000'

  data.forEach(function (d) {
    // setTimeout(function() { context.fillRect(d[0],d[1],1,1); }, 500);
    context.fillRect(d[0], d[1], dotSize, dotSize)
  })
}

// --------------------
// --------------------
// -------------------- 2nd Vis
// --------------------
// --------------------

function requestSecondData (searchText, xPos, yPos, radius) {
  var enumSearch = searchText.toUpperCase().replace(/, /g, '_').replace(/-/g, '_').replace(/\./g, '_').replace(/ /g, '_')
  const semesterRange = { start: semester }

  showLoaderOverlay(true)

  apolloClient.query({
    query: COURSES_SEARCH_QUERY,
    variables: {
      page: 1,
      perPage: 1000,
      departments: enumSearch,
      semesterRange: semesterRange
    }
  }).then(function (response) {
    const courses = response.data.coursesConnection.edges.map(course => course.node)
    closeUpVis(courses, xPos, yPos, radius)
    showLoaderOverlay(false)
  })
}

function removeCloseUpVis () {
  svg.select('#closeUpGroup').remove()
}

function closeUpVis (data, xPos, yPos, radius) {
  var packCloseUp = d3.pack()
    .size([diameter * 0.8, diameter * 0.8])
    .padding(10)

  var rootCloseUp = d3.hierarchy({ children: data })
    .sum(function (d) { return 1 })

  packCloseUp(rootCloseUp)

  xPos = xPos - diameter * 0.1
  yPos = yPos - diameter * 0.1

  var closeUpGroup = svg.append('g').attr('id', 'closeUpGroup')
    .attr('transform', 'translate(' + diameter * 0.1 + ',' + diameter * 0.1 + ')')

  var node = closeUpGroup.selectAll('g')
    .data(rootCloseUp.children)
    .enter()
    .append('g')
    .attr('class', 'node closeUpNode')
    .attr('transform', function () {
      var xRan = d3.randomNormal(xPos, radius / 4)
      var yRan = d3.randomNormal(yPos, radius / 4)
      return 'translate(' + xRan() + ',' + yRan() + ')'
    })

  node.append('circle')
    .attr('id', function (d) { return 'node-' + d.data.id })
    .attr('r', function (d) { return dotSize })
    .transition()
    .delay(500)
    .duration(500)
    .attr('r', function (d) { return d.r })

  node.transition()
    .duration(1000)
    .attr('transform', function (d) { return 'translate(' + d.x + ',' + d.y + ')' })

  setTimeout(function () {
    node
      .on('mouseover', function () {
        tooltipOn(this)
      })
      .on('mouseout', function () {
        tooltipOff()
      })
      .on('click', function () {
        courseClick(this)
      })
  }, 500)
}

function tooltipOn (node) {
  const data = node.__data__
  const absoluteCoords = node.getBoundingClientRect()

  tooltipDiv.transition()
    .duration(200)
    .style('opacity', 1)

  // Tooltips are 200px wide, so subtract 100px to center them below their related circles
  const xPos = absoluteCoords.left - 100 + (absoluteCoords.width / 2)
  const yPos = absoluteCoords.top + absoluteCoords.height + 12

  tooltipDiv.html(data.data.title + '<br/>' + data.data.subject_description)
    .style('left', xPos + 'px')
    .style('top', yPos + 'px')
}

function tooltipOff () {
  tooltipDiv.transition()
    .duration(200)
    .style('opacity', 0)
}

function courseClick (course) {
  let courseData = _.clone(course.__data__.data)

  courseData.schedule = transformSchedule(courseData)

  selectCourse(courseData)
}

export { initSetup }
