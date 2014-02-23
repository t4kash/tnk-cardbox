'use strict'

angular.module('tnkCardboxApp')
  .controller 'MainCtrl', ($scope, $location, cardAttribute, cardService, rarityFilter) ->

    if !Parse.User.current()
      $scope.logout()
      return

    # init
    $scope.prefectures = cardAttribute.prefectures
    $scope.regions = cardAttribute.regions
    $scope.cardTypes = cardAttribute.cardTypes
    $scope.rarities = cardAttribute.rarities
    $scope.items = []
    $scope.filteredItems = []
    $scope.loading = false

    $scope.predicateColumn = 'attack'
    $scope.predicate = 'attack'
    $scope.reverse = true

    # fetch card list
    $scope.fetchCardList = ->
      $scope.loading = true
      $scope.items = []

      cardService.findCardList({
        success: (results) ->
          console.log "total: " + results.length
          $scope.$apply( ->
            $scope.items = []

            for result in results
              item = angular.copy result.attributes
              item.id = result.id
              item.selected = false
              $scope.items.push item

            $scope.loading = false
          )
        error: (error) ->
          # エラー
          console.log(error.code + ' ' + error.message)
          if error.code == Parse.Error.OBJECT_NOT_FOUND
            $scope.logout()

          $scope.$apply( ->
            $scope.loading = false
          )
      })

    $scope.fetchCardList()

    # change sort order
    $scope.sort = (column) ->
      if column == $scope.predicateColumn
        $scope.reverse = !$scope.reverse
      else
        $scope.predicateColumn = column

        if column == 'rarity'
          $scope.predicate = (item) ->
            return cardAttribute.rarities.indexOf(rarityFilter(item.rarity))
        else
          $scope.predicate = column

        $scope.reverse = false

    # css class for sort column
    $scope.sortClass = (column) ->
      if column != $scope.predicateColumn
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
    $scope.regionFilterFunc = (item) ->
      if !$scope.searchRegion? || $scope.searchRegion == ""
        return true
      else
        return $scope.searchRegion == cardAttribute.regionByPrefecture item.region

    # レア度検索用filter
    $scope.rarityFilterFunc = (item) ->
      if !$scope.searchRarity? || $scope.searchRarity == ""
        return true
      else
        return $scope.searchRarity == rarityFilter(item.rarity)

    # 全選択
    $scope.toggleAll = ->
      angular.forEach($scope.filteredItems, (item) ->
        item.selected = $scope.checkboxAll
      )

    # delete card
    $scope.deleteCard = ->
      cardIds = []
      for item in $scope.items
        if item.selected
          cardIds.push item.id

      if cardIds.length == 0
        alert "削除するカード情報を選択してください"
      else
        if !confirm(cardIds.length + "件のカード情報を削除します")
          return

      $scope.loading = true

      cardService.findCardListInIds(cardIds).then((results) ->
        # promise数珠つなぎで消していく
        promise = Parse.Promise.as()
        angular.forEach(results, (result) ->
          promise = promise.then(->
            angular.forEach($scope.items, (item, i) ->
              if item.id == result.id
                $scope.$apply( ->
                  $scope.items.splice(i, 1)
                )
            )
            return result.destroy()
          )
        )

        # 終わったらloading off
        promise.always( ->
          $scope.$apply( ->
            $scope.loading = false
          )
        )
      )


    # CSV data
    $scope.csvData = ->
      csv = []
      angular.forEach($scope.filteredItems, (item, i) ->
        csv.push({
          name: item.name
          nameKana: item.nameKana
          rarity: rarityFilter(item.rarity)
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


