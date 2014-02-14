'use strict'

angular.module('tnkCardboxApp')
  .filter 'rarity', () ->
    (input) ->
      rare = {
        normal: "N"
        rare: "R"
        hrare: "HR"
        srare: "S"
        ssrare: "SS"
        special: "SP"
      }
      return rare[input]
