pw.component.register("block-highlighter", function (view, config) {
  var that = this;

  this.findBlocksById = function (id) {
    return $(view.node).find('li[data-id="' + id + '"]');
  };

  this.highlightBlocks = function (blocks) {
    blocks.addClass('highlight');
  };

  this.unhighlightBlocks = function (blocks) {
    blocks.removeClass('highlight');
  };

  this.listen("visibility:status", function (args) {
    var blocks = that.findBlocksById(args.element.dataset.id);
    if (!!blocks.length > 0) {
      if (args.visible) {
        that.highlightBlocks(blocks);
      } else {
        that.unhighlightBlocks(blocks);
      }
    }
  });
});

pw.component.register("scroll-broadcaster", function (view, config) {
  this.init = function () {
    $(view.node).on('scroll', function () {
      pw.component.broadcast('scrolling');
    });
  };
});

pw.component.register("visibility-broadcaster", function (view, config) {
  var that = this;
  var scroller, visible;

  this.init = function () {
    scroller = document.querySelector(config.rel || window);
  };

  this.checkVisibility = function (e) {
    var currentlyVisible = false;

    var docViewTop = scroller.scrollTop;
    var docViewBottom = docViewTop + scroller.offsetHeight;
    var elemTop = view.node.offsetTop;
    var elemBottom = elemTop + view.node.offsetHeight;

    if (elemBottom > docViewTop || elemTop < docViewBottom) {
      // it's at least possible for element to be visible, need to know more

      if ((elemBottom <= docViewBottom) && (elemTop >= docViewTop)) {
        // entire element is currently visible
        currentlyVisible = true;
      } else {
        var minPercent = 0.4;
        var minHeight = (docViewBottom - docViewTop) * minPercent;
        if (
            ((elemBottom >= docViewBottom) && (docViewBottom - elemTop >= minHeight)) ||
            ((elemTop <= docViewTop) && (elemBottom - docViewTop >= minHeight))
           ) {
          // element is taking up at least minPercent of scrollable area
          currentlyVisible = true;
        }
      }
    }

    if (visible && !currentlyVisible) {
      // update ourselves
      visible = false;
      // tell everyone else
      view.node.classList.remove('visible');
      pw.component.broadcast("visibility:status", { visible: false, element: view.node });
    } else if (!visible && currentlyVisible) {
      // update ourselves
      visible = true;
      // tell everyone else
      view.node.classList.add('visible');
      pw.component.broadcast("visibility:status", { visible: true, element: view.node });
    }
  };

  this.listen('scrolling', that.checkVisibility);
});
