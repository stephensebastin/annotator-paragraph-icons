class global.ParagraphButtons
  constructor: (@_onClick) ->

  _paragraphHasContent: (el) ->
    $clonedEl = $(el).clone()
    $clonedEl.find('a').remove() # Strip links

    textLength = $clonedEl.text().trim().replace(/\s\s+/g, ' ').length
    $clonedEl.remove()

    textLength >= 50

  _addParagraphButton: (el) ->
    return unless @_paragraphHasContent(el)

    new global.ParagraphIconButtonContainer el, =>
      @_onClick(el)

  _addParagraphButtonsBatch: (elements) ->
    for el in elements[0...10]
      @_addParagraphButton el

    elementsLeft = elements[10..]
    if elementsLeft.length > 0
      setTimeout (=> @_addParagraphButtonsBatch(elementsLeft)), 200

  _paragraphSelectors: ->
    ['p', 'li', 'dd', 'dt', '.paragraph', '.para', '.par', '.text', '.summary']

  _prefixedParagraphSelectors: (prefix) ->
    (prefix + ' ' + selector for selector in @_paragraphSelectors())

  _defaultSelector: ->
    @_paragraphSelectors().join(',')

  _articleContainerSelector: ->
    selectors = [
      'article', 'div.article', 'div.story', 'div.single-post', 'div.post'
      'div#bodyContent', 'div#content', 'div.content', 'div#main', 'div.main'
      'div#page', 'div.page', 'div#site', 'div.site'
    ]

    for selector in selectors
      $element = $(selector)
      # Only match if selector is unique
      if $element.length == 1 && $element.is(':visible')
        return @_prefixedParagraphSelectors(selector).join(',')

    null

  _paragraphElements: ->
    selector = @_articleContainerSelector() || @_defaultSelector()
    console.info 'Paragraph selector:', selector

    $(selector).distinctDescendants().filter(':visible')

  addParagraphButtons: ->
    @_addParagraphButtonsBatch @_paragraphElements()
