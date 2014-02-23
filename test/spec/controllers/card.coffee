'use strict'

describe 'Controller: CardCtrl', () ->

  # load the controller's module
  beforeEach module 'tnkCardboxApp'

  CardCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    CardCtrl = $controller 'CardCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
