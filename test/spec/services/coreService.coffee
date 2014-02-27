'use strict'

describe 'Service: coreService', () ->

  # load the service's module
  beforeEach module 'tnkCardboxApp'

  # instantiate service
  coreService = {}
  beforeEach inject (_coreService_) ->
    coreService = _coreService_

  it 'should do something', () ->
    expect(!!coreService).toBe true
