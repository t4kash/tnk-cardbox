'use strict'

describe 'Directive: textMatch', () ->

  # load the directive's module
  beforeEach module 'tnkCardboxApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<text-match></text-match>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the textMatch directive'
