'use strict'

angular.module('tnkCardboxApp')
  .controller 'MainCtrl', ($scope, $location, cardRegion) ->

    # ログアウト
    $scope.logout = ->
      Parse.User.logOut()
      $location.path "/"

    if !Parse.User.current()
      $scope.logout()
      return

    # init
    $scope.prefectures = cardRegion.prefectures
    $scope.regions = cardRegion.regions
    $scope.items = []

    $scope.predicate = 'rarity'
    $scope.reverse = true

    $scope.fetchCard = ->
      Card = Parse.Object.extend "Card"
      query = new Parse.Query Card
      query.equalTo("user", Parse.User.current())

      query.find({
        success: (results) ->
          console.log "total: " + results.length
          $scope.$apply( ->
            $scope.items = []

            for result in results
              $scope.items.push result.attributes
          )
        error: (error) ->
          # エラー
          console.log(error.code + ' ' + error.message)
          if error.code == Parse.Error.OBJECT_NOT_FOUND
            $scope.logout()

      })

    $scope.fetchCard()

    # change sort order
    $scope.sort = (column) ->
      if column == $scope.predicate
        $scope.reverse = !$scope.reverse
      else
        $scope.predicate = column
        $scope.reverse = false

    # css class for sort column
    $scope.sortClass = (column) ->
      if column != $scope.predicate
        return 'fa-sort'
      else if $scope.reverse
        return 'fa-sort-desc'
      else
        return 'fa-sort-asc'

    # select comparator
    $scope.strictComparator = (actual, expected) ->
      if expected == ""
        return true
      else
        return angular.equals(expected, actual)

    # 地方検索用filter
    $scope.regionFilter = (item) ->
      if $scope.searchRegion == ""
        return true
      else
        return $scope.searchRegion == cardRegion.regionByPrefecture item.region

    # CSV data
    $scope.csvData = ->
      csv = []
      angular.forEach($scope.items, (item, i) ->
        csv.push({
          name: item.name
          nameKana: item.nameKana
          rarity: item.rarity
          region: item.region
          level: item.level
          maxLevel: item.maxLevel
          extendLevel: item.extendLevel
          cost: item.cost
          attack: item.attack
          defence: item.defence
          type: item.type
          skill: item.skill
          skillLevel: item.skillLevel
          skillName: item.skillName
        })
      )

      return csv


