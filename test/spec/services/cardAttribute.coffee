'use strict'

describe 'Service: cardAttribute', () ->

  # load the service's module
  beforeEach module 'tnkCardboxApp'

  # instantiate service
  cardAttribute = {}
  beforeEach inject (_cardAttribute_) ->
    cardAttribute = _cardAttribute_

  it 'should do something', () ->
    expect(!!cardAttribute).toBe true
