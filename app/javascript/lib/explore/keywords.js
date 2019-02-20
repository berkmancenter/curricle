import $ from 'jquery'
import * as d3 from 'd3'
import _ from 'lodash'
import apolloClient from 'apollo'
import COURSES_SEARCH_QUERY from '../../graphql/CoursesSearch.gql'
import { transformSchedule } from 'lib/util'
//  Colors

// var colorLeft = '#B53139';
// var colorRight = '#B87D42';
// var colorMix = '#5997B2';

// var colorLeft = '#F27C21';
// var colorRight = '#5083D4';
// var colorMix = '#C22076';

var colorLeft = '#f0cf61'
var colorRight = '#005397'
var colorMix = '#32b67a' // 167c80

var maxTextLength = 30

var datasetOne = []
var datasetTwo = []

var leftSelection = 'Truth'
var rightSelection = 'Lies'

var sideData = 'searchTerm'
var centerData = 'subject_description' // component subject_description

var textPaddingSideViz = 200

var minDocumentWidth = 350
var documentHeight = 100

// main 'container' area is 10 columns wide (out of 12 total) with 5% padding on left/right
var containerWidth = window.innerWidth * 0.8333333 * 0.9

var documentWidth = Math.max(containerWidth, minDocumentWidth)

var margin = { top: 50, right: 0, bottom: 50, left: 0 }
var width = documentWidth - margin.left - margin.right
var height = documentHeight - margin.top - margin.bottom

var linesGroup
var textGroup
var typeTextScale
var networkWidthScale

var fullData

let selectCourse
let semester
let showLoaderOverlay

function requestData (searchTerm, numTerm) {
  const semesterRange = { start: semester }

  showLoaderOverlay(true)

  apolloClient.query({
    query: COURSES_SEARCH_QUERY,
    variables: {
      page: 1,
      perPage: 5000,
      semesterRange: semesterRange,
      deluxeKeywords: [{
        text: searchTerm,
        applyTo: ['TITLE', 'DESCRIPTION']
      }]
    }
  }).then(function (response) {
    // course objects need to be cloned so that they can be extended by addToDataSet()
    const courses = response.data.coursesConnection.edges.map(course => _.clone(course.node))
    addToDataSet(courses, searchTerm, numTerm)
    showLoaderOverlay(false)
  })
}

function addToDataSet (data, searchTerm, numTerm) {
  data.forEach(function (d) {
    d.searchTerm = searchTerm
    d.numTerm = numTerm
  })

  if (numTerm === 1) {
    datasetOne = data
  } else {
    datasetTwo = data
  }

  mergeData()
}

function mergeData () {
  fullData = datasetOne.concat(datasetTwo)

  setData(fullData)
}

function initSetup (selectCourseFunction, selectedSemester, showLoaderOverlayFunction) {
  semester = selectedSemester
  selectCourse = selectCourseFunction
  showLoaderOverlay = showLoaderOverlayFunction
  centerData = 'subject_description'

  // remove existing SVGs prior to (re)drawing new ones
  d3.select('#visContainer').selectAll('svg').remove()

  var svg = d3.select('#visContainer').append('svg')
    .attr('width', width + margin.left + margin.right)
    .attr('height', height + margin.top + margin.bottom)
    .append('g')
    .attr('transform', 'translate(' + 0 + ',' + margin.top + ')')

  linesGroup = svg.append('g')
  textGroup = svg.append('g')

  typeTextScale = d3.scaleLinear()
    .domain([1, 100])
    .range([12, 12])

  networkWidthScale = d3.scaleLinear()
    .range([1, 10])

  var mixGradientLeft = svg.append('defs')
    .append('linearGradient')
    .attr('id', 'mixGradientLeft')
    .attr('x1', '0%')
    .attr('y1', '0%')
    .attr('x2', '100%')
    .attr('y2', '0%')

  mixGradientLeft.append('stop')
    .attr('offset', '0%')
    .attr('stop-color', colorLeft)
    .attr('stop-opacity', 0)

  mixGradientLeft.append('stop')
    .attr('offset', '30%')
    .attr('stop-color', colorLeft)
    .attr('stop-opacity', 1)

  mixGradientLeft.append('stop')
    .attr('offset', '70%')
    .attr('stop-color', colorMix)
    .attr('stop-opacity', 1)

  mixGradientLeft.append('stop')
    .attr('offset', '100%')
    .attr('stop-color', colorMix)
    .attr('stop-opacity', 0)

  var mixGradientRight = svg.append('defs')
    .append('linearGradient')
    .attr('id', 'mixGradientRight')
    .attr('x1', '0%')
    .attr('y1', '0%')
    .attr('x2', '100%')
    .attr('y2', '0%')

  mixGradientRight.append('stop')
    .attr('offset', '0%')
    .attr('stop-color', colorMix)
    .attr('stop-opacity', 0)

  mixGradientRight.append('stop')
    .attr('offset', '30%')
    .attr('stop-color', colorMix)
    .attr('stop-opacity', 1)

  mixGradientRight.append('stop')
    .attr('offset', '70%')
    .attr('stop-color', colorRight)
    .attr('stop-opacity', 1)

  mixGradientRight.append('stop')
    .attr('offset', '100%')
    .attr('stop-color', colorRight)
    .attr('stop-opacity', 0)

  var leftGradient = svg.append('defs')
    .append('linearGradient')
    .attr('id', 'leftGradient')
    .attr('x1', '0%')
    .attr('y1', '0%')
    .attr('x2', '100%')
    .attr('y2', '0%')

  leftGradient.append('stop')
    .attr('offset', '0%')
    .attr('stop-color', colorLeft)
    .attr('stop-opacity', 0)

  leftGradient.append('stop')
    .attr('offset', '30%')
    .attr('stop-color', colorLeft)
    .attr('stop-opacity', 1)

  leftGradient.append('stop')
    .attr('offset', '70%')
    .attr('stop-color', colorLeft)
    .attr('stop-opacity', 1)

  leftGradient.append('stop')
    .attr('offset', '100%')
    .attr('stop-color', colorLeft)
    .attr('stop-opacity', 0)

  var rightGradient = svg.append('defs')
    .append('linearGradient')
    .attr('id', 'rightGradient')
    .attr('x1', '0%')
    .attr('y1', '0%')
    .attr('x2', '100%')
    .attr('y2', '0%')

  rightGradient.append('stop')
    .attr('offset', '0%')
    .attr('stop-color', colorRight)
    .attr('stop-opacity', 0)

  rightGradient.append('stop')
    .attr('offset', '30%')
    .attr('stop-color', colorRight)
    .attr('stop-opacity', 1)

  rightGradient.append('stop')
    .attr('offset', '70%')
    .attr('stop-color', colorRight)
    .attr('stop-opacity', 1)

  rightGradient.append('stop')
    .attr('offset', '100%')
    .attr('stop-color', colorRight)
    .attr('stop-opacity', 0)

  requestData(leftSelection, 1)

  setTimeout(function () {
    requestData(rightSelection, 2)
  }, 1000)

  $('#dimContainer li').on('click', function (event) {
    centerData = $(this).attr('value')

    $('#dimContainer li').removeClass('active')
    $(this).addClass('active')

    setData(fullData)
  })

  $('#searchBoxOne').keyup(function (event) {
    if (event.keyCode !== 13) {
      return
    }

    leftSelection = document.getElementById('searchBoxOne').value

    requestData(leftSelection, 1)
  })

  $('#searchBoxTwo').keyup(function (event) {
    if (event.keyCode !== 13) {
      return
    }

    rightSelection = document.getElementById('searchBoxTwo').value

    requestData(rightSelection, 2)
  })
}

function setData (data) {
  if (data.length) {
    var nestedData = d3.nest()
      .key(function (d) { return d[sideData] })
      .rollup(function (v) {
        return {
          count: v.length
        }
      })
      .entries(data)

    nestedData.sort(function (a, b) {
      return b.value.count - a.value.count
    })
  }

  function redraw () {
    containerWidth = window.innerWidth * 0.8333333 * 0.9
    documentWidth = Math.max(containerWidth, minDocumentWidth)

    d3.select('#visContainer')
      .select('svg')
    // .transition()
      .attr('width', +documentWidth)

    dataPrepCenterVis(data)
    setSideTextVis(nestedData)
  }

  window.addEventListener('resize', redraw)

  dataPrepCenterVis(data)
  setSideTextVis(nestedData)
}

function setSideTextVis (nestedData) {
  const leftTextLeft = textPaddingSideViz - 115
  const rightTextLeft = documentWidth - textPaddingSideViz
  const top = documentHeight / 2 + 60

  var leftText = d3.select('#searchOne')

  leftText.transition().duration(500)
    .style('left', leftTextLeft + 'px')
    .style('top', top + 'px')

  var rightText = d3.select('#searchTwo')

  rightText.transition().duration(500)
    .style('left', rightTextLeft + 'px')
    .style('top', top + 'px')

  // var rightData = nestedData.filter(function (d) {
  //   return d.key === rightSelection
  // })
}

// function showCountSideVis () {
//   var thisData = this.__data__

//   if (this.classList[0] === 'leftText') {
//     d3.select(this).text(function (d) { return d.value.count + ' - ' + d.key })
//   } else {
//     d3.select(this).text(function (d) { return d.key + ' - ' + d.value.count })
//   }
// }

// function removeCountSideVis () {
//   d3.select(this).text(function (d) {
//     if (d.key.length > maxTextLength) { return d.key.substring(0, maxTextLength) + '...' } else { return d.key }
//   })
// }

function dataPrepCenterVis (filteredData) {
  // var filteredData = fullData //.filter(function(d) { return d[sideData] === leftSelection || d[sideData] === rightSelection });

  var nestedData = d3.nest()
    .key(function (d) { return centerData === 'title' ? d['id'] : d[centerData] })
    .key(function (d) { return d[sideData] })
    .rollup(function (v) {
      return {
        count: v.length,
        data: v
      }
    })
    .entries(filteredData)

  nestedData.forEach(function (d) {
    if (d.values.length === 1) {
      d.totalCount = d.values[0].value.count
      d.maxCount = d.values[0].value.count
      if (d.values[0].key === leftSelection) {
        d.pos = d.values[0].value.count * -1
      } else {
        d.pos = d.values[0].value.count
      }
    } else {
      d.totalCount = d.values[0].value.count + d.values[1].value.count
      d.maxCount = Math.max(d.values[0].value.count, d.values[1].value.count)
      if (d.values[0].value.count > d.values[1].value.count) {
        d.pos = (d.values[0].value.count * -1) / 100000
      } else {
        d.pos = d.values[0].value.count / 100000
      }
    }
  })

  var sortedData = nestedData.sort(function (a, b) {
    return b.pos - a.pos
  })

  var textPosCount = 0

  sortedData.forEach(function (d, i) {
    textPosCount += typeTextScale(+d.totalCount) * 1.4
    d.textPosCount = Math.round(textPosCount)
  })

  setCenterVis(sortedData)
}

function setCenterVis (sortedData) {
  d3.selectAll('#container').remove()

  var centerText = textGroup.selectAll('.centerText')
    .data(sortedData, function (d) { return d.key })

  centerText.exit().remove()

  centerText.transition().duration(500)
    .style('font-size', function (d) { return typeTextScale(+d.totalCount) + 'px' })
    .attr('transform', function (d, i) {
      return 'translate(' + (documentWidth / 2) + ',' + d.textPosCount + ')'
    })
    .style('fill', function (d) {
      if (d.values.length === 1) {
        if (d.values[0].key === leftSelection) {
          return colorLeft
        } else {
          return colorRight
        }
      } else {
        return colorMix
      }
    })

  centerText
    .enter()
    .append('text')
    .attr('class', function (d) { return 'centerText ' + d.key })
    .attr('transform', function (d, i) {
      return 'translate(' + (documentWidth / 2) + ',' + d.textPosCount + ')'
    })
    .style('text-anchor', 'middle')
    .style('opacity', 1)
    .style('fill', function (d) {
      if (d.values.length === 1) {
        if (d.values[0].key === leftSelection) {
          return colorLeft
        } else {
          return colorRight
        }
      } else {
        return colorMix
      }
    })
    .style('font-size', function (d) { return typeTextScale(+d.totalCount) + 'px' })
    .text(function (d) {
      const title = (centerData === 'title') ? d.values[0].value.data[0].title : d.key

      return (title.length > maxTextLength) ? title.substring(0, maxTextLength) + '...' : title
    })
    .on('click', centerClick)
    .on('mouseover', showCountCenterVis)
    .on('mouseout', removeCountCenterVis)
    .transition()
    .delay(500)
    .duration(500)
    .style('opacity', 1)

  const height = sortedData.length ? sortedData[sortedData.length - 1].textPosCount : 0

  documentHeight = height + margin.top + margin.bottom

  if (documentHeight < 300) {
    documentHeight = 300
  }

  d3.select('svg')
    .transition()
    .attr('height', documentHeight)

  drawConnectionLines(sortedData)
}

function centerClick () {
  var selectedKey = this.__data__.key

  var selectionData = fullData.filter(function (d) {
    const key = (centerData === 'title') ? 'id' : centerData

    return d[key] === selectedKey
  })

  // Courses at the intersection of both keywords will be in the selectionData array twice
  const uniqueCourses = _.uniqBy(selectionData, 'id')

  if (centerData === 'title' && uniqueCourses.length === 1) {
    const course = _.clone(selectionData[0])

    course.schedule = transformSchedule(course)

    selectCourse(course)
  }

  centerData = 'title'

  setData(selectionData)

  $('#dimContainer li').removeClass('active')
  $('#dimClass').addClass('active')
}

function showCountCenterVis () {
  var thisData = this.__data__

  d3.select(this).text(function (d) {
    const title = (centerData === 'title') ? d.values[0].value.data[0].title : d.key

    if (thisData.values.length === 1) {
      if (thisData.values[0].key === leftSelection) {
        return d.values[0].value.count + ' - ' + title
      } else {
        return title + ' - ' + d.values[0].value.count
      }
    } else {
      return d.values[0].value.count + ' - ' + title + ' - ' + d.values[1].value.count
    }
  })
}
function removeCountCenterVis () {
  d3.select(this).text(function (d) {
    const title = (centerData === 'title') ? d.values[0].value.data[0].title : d.key

    return (title.length > maxTextLength) ? title.substring(0, maxTextLength) + '...' : title
  })
}

function drawConnectionLines (data) {
  d3.selectAll('.connectionLinesGroup').remove()

  var x1Left = textPaddingSideViz
  var x1Right = documentWidth - textPaddingSideViz
  var x1
  var x2 = documentWidth / 2
  var y1 = documentHeight / 2 - 5
  var y2 = 100
  var yHalf = 0
  var bendPos = documentWidth / 10

  var maxCountVal = d3.max(data, function (d) { return d.maxCount })

  if (maxCountVal < 11) {
    networkWidthScale.range([1, maxCountVal])
  } else {
    networkWidthScale.range([1, 10])
  }
  networkWidthScale.domain([1, maxCountVal])

  var connectionLinesContainer = linesGroup.selectAll('.connectionLinesGroup')
    .data(data)

  connectionLinesContainer.enter()
    .append('g')
    .attr('class', 'connectionLinesGroup')
    .each(function (segment, i) {
      var connectionLines = d3.select(this)
        .selectAll('.connectionLines')
        .data(segment.values)

      connectionLines.enter()
        .append('path')
        // .attr('class', function(d) { return 'connectionLines id'+d.values[0].source+ ' id'+d.values[0].target; })
        .attr('d', function (j) {
          if (j.key === leftSelection) {
            x1 = x1Left
            x2 = documentWidth / 2 - typeTextScale(segment.totalCount)
            yHalf = x1 + bendPos
          } else {
            x1 = x1Right
            x2 = documentWidth / 2 + typeTextScale(segment.totalCount)
            yHalf = x1 - bendPos
          }

          y2 = segment.textPosCount // - (segment.totalCount/2)

          return 'M' + x1 + ',' + y1 +
              'C' + yHalf + ',' + y1 +
              ' ' + yHalf + ',' + (y2 - typeTextScale(segment.totalCount) / 3) +
              ' ' + x2 + ',' + (y2 - typeTextScale(segment.totalCount) / 3)
        })
        .style('stroke', function (j) {
          if (segment.values.length === 2) {
            if (j.key === leftSelection) {
              return 'url(#mixGradientLeft)'
            } else {
              return 'url(#mixGradientRight)'
            }
          } else {
            if (j.key === leftSelection) {
              return 'url(#leftGradient)'
            } else {
              return 'url(#rightGradient)'
            }
          }
        })
        .style('stroke-width', function (j) {
          return networkWidthScale(j.value.count)
        })
        .style('opacity', 1)
        .style('fill', 'none')
    })
}

export { initSetup }
