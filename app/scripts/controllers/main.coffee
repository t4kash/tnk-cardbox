'use strict'

angular.module('tnkCardboxApp')
  .controller 'MainCtrl', ($scope, $rootScope, $location, coreService, cardAttribute, cardService, rarityFilter) ->

    if !Parse.User.current()
      coreService.logout()
      return

    # init
    $scope.prefectures = cardAttribute.prefectures
    $scope.regions = cardAttribute.regions
    $scope.cardTypes = cardAttribute.cardTypes
    $scope.rarities = cardAttribute.rarities
    $scope.filteredCards = []
    $scope.loading = false

    $scope.predicateColumn = 'attack'
    $scope.predicate = 'attack'
    $scope.reverse = true

    # fetch card list
    $scope.fetchCardList = (force) ->
      $scope.loading = true

      cardService.refreshCardList({
        success: () ->
          $scope.loading = false
        error: (error) ->
          # エラー
          if error.code == Parse.Error.OBJECT_NOT_FOUND
            coreService.logout()

          $scope.loading = false
      }, force)

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
      angular.forEach($scope.filteredCards, (item) ->
        item.selected = $scope.checkboxAll
      )

    # delete card
    $scope.deleteCard = ->
      cardIds = []
      for item in $rootScope.cards
        if item.selected
          cardIds.push item.object.id

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
            angular.forEach($rootScope.cards, (item, i) ->
              if item.object.id == result.id
                $scope.$apply( ->
                  $rootScope.cards.splice(i, 1)
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
      angular.forEach($scope.filteredCards, (item, i) ->
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


