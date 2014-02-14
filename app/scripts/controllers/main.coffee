'use strict'

angular.module('tnkCardboxApp')
  .controller 'MainCtrl', ($scope, $location) ->

    # ログアウト
    $scope.logout = ->
      NCMB.User.logOut()
      $location.path "/"

    if !NCMB.User.current()
      $scope.logout()
      return

    # init
    $scope.items = []

    $scope.predicate = 'rarity'
    $scope.reverse = true

    $scope.fetchCard = ->
      Card = NCMB.Object.extend "Card"
      query = new NCMB.Query Card
      #query.equalTo("user", NCMB.User.current())
      query.find({
        success: (results) ->
          console.log results
          $scope.$apply( ->
            $scope.items = []

            for result in results
              $scope.items.push result.attributes
          )
        error: (error) ->
          # エラー
          console.log(error.code + ' ' + error.message)
          if error.code == "E401001"
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


