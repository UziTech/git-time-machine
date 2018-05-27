
{$, View} = require "atom-space-pen-views"
_ = require 'underscore-plus'

module.exports = class GitTimeplot
  className: 'gtm-hz-scroller'

  constructor: (@$parentElement)->
    @_debouncedOnScroll = _.debounce @_onScroll, 100
    
    @$element = @$parentElement.find(".#{@className}")
    unless @$element?.length > 0
      @$element = $("<div class='#{@className}'>")
      @$parentElement.append @$element
      @$element.on 'scroll.gtmHzScroller', @_onScroll


  render: ->
    @_toggleTouchAreas()
    return @$element


  scrollFarRight: () ->
    @$element.scrollLeft(@_getChildWidth() - @$element.width())


  _onScroll: =>
    @_toggleTouchAreas()


  _toggleTouchAreas: ->
    @_toggleTouchArea('left')
    @_toggleTouchArea('right')


  _toggleTouchArea: (which)->
    $touchArea = @$element.find(".gtm-#{which}-touch-area")
    unless $touchArea.length > 0
      $touchArea = $("<div class='gtm-#{which}-touch-area'>")
      @$element.prepend($touchArea)
    
    scrollLeft = @$element.scrollLeft()
    relativeRight = @$element.scrollLeft() + @$element.width()
    
    {shouldHide, areaLeft} = switch which
      when 'left'
        shouldHide: scrollLeft == 0
        areaLeft: scrollLeft
      when 'right'
        shouldHide: relativeRight >= @_getChildWidth() - 10
        areaLeft: relativeRight - 20
    
    if shouldHide
      $touchArea.hide()
    else
      $touchArea.css({left: areaLeft})
      $touchArea.show()


  _getChildWidth: ->
    @$element.find('.timeplot').outerWidth(true)
    



