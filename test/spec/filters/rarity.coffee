'use strict'

describe 'Filter: rarity', () ->

  # load the filter's module
  beforeEach module 'tnkCardboxApp'

  # initialize a new instance of the filter before each test
  rarity = {}
  beforeEach inject ($filter) ->
    rarity = $filter 'rarity'

  it 'should return the input prefixed with "rarity filter:"', () ->
    text = 'angularjs'
    expect(rarity text).toBe ('rarity filter: ' + text)
