'use strict'

angular.module('tnkCardboxApp')
  .filter 'rarity', () ->
    (input) ->
      rare = {
        normal: "N"
        hnormal: "HN"
        rare: "R"
        hrare: "HR"
        srare: "SR"
        ssrare: "SSR"
        special: "SP"
      }
      return rare[input]
