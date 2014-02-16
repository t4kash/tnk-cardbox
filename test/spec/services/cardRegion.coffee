'use strict'

describe 'Service: Cardregion', () ->

  # load the service's module
  beforeEach module 'tnkCardboxApp'

  # instantiate service
  Cardregion = {}
  beforeEach inject (_Cardregion_) ->
    Cardregion = _Cardregion_

  it 'should do something', () ->
    expect(!!Cardregion).toBe true
