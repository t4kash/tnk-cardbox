'use strict'

angular.module('tnkCardboxApp')
  .controller 'CardCtrl', ['$scope', '$rootScope', '$location', '$routeParams', 'coreService', 'cardService', 'cardAttribute', ($scope, $rootScope, $location, $routeParams, coreService, cardService, cardAttribute) ->

    if !coreService.getUser()
      coreService.logout()
      return

    $scope.regions = cardAttribute.regions.concat(cardAttribute.prefectures)
    $scope.cardTypes = cardAttribute.cardTypes
    $scope.rarities = cardAttribute.rarities2
    $scope.skillEffectTypes = cardAttribute.skillEffectTypes
    $scope.skillEffectSigns = cardAttribute.skillEffectSigns
    $scope.card = {}
    $scope.processing = false
    $scope.errorMessage = ''

    ###*
     * カード情報読み込み
    ###
    showCard = (objectId) ->
      $rootScope.loading = true
      cardService.getCardWithRefreshList(objectId, {
        success: (result) ->
          if result?
            $scope.card = result
          $rootScope.loading = false
        error: (error) ->
          $rootScope.loading = false
      })

    ###*
     * 保存
    ###
    $scope.save = ->
      $scope.processing = true

      if !$routeParams.objectId?
        # 新規追加
        user = Parse.User.current()
        Card = Parse.Object.extend("Card")
        $scope.card.object = new Card()
        $scope.card.object.setACL(new Parse.ACL(user))
        $scope.card.object.set("user", user)
        #$scope.card.object.set("cardId", cardService.guid())
        $scope.card.object.set("extendLevel", 0)

      # 新規・変更 共通
      $scope.card.object.set("name", $scope.card.name)
      $scope.card.object.set("nameKana", $scope.card.nameKana)
      $scope.card.object.set("rarity", $scope.card.rarity)
      $scope.card.object.set("region", $scope.card.region)
      $scope.card.object.set("level", $scope.card.level)
      $scope.card.object.set("maxLevel", $scope.card.maxLevel)
      $scope.card.object.set("cost", $scope.card.cost)
      $scope.card.object.set("attack", $scope.card.attack)
      $scope.card.object.set("defence", $scope.card.defence)
      $scope.card.object.set("type", $scope.card.type)
      $scope.card.object.set("skill", $scope.card.skill)
      $scope.card.object.set("skillLevel", $scope.card.skillLevel)
      $scope.card.object.set("skillName", $scope.card.skillName)
      $scope.card.object.set("skillTarget", $scope.card.skillTarget)
      $scope.card.object.set("skillEffectType", parseInt($scope.card.skillEffectType))
      $scope.card.object.set("skillEffectRate", $scope.card.skillEffectRate)
      $scope.card.object.set("skillEffectSign", parseInt($scope.card.skillEffectSign))

      $scope.card.object.save(null, {
        success: (result) ->
          $scope.$apply( ->
            $scope.card = angular.copy result.attributes
            $scope.card.id = result.id
            $scope.card.object = result
            cardService.updatedCard result
            $scope.processing = false
            $location.path "/main"
          )
        error: (result, error) ->
          $scope.$apply( ->
            $scope.errorMessage = "エラー:" + error.code
            $scope.processing = false
          )
      })


    # init
    if $routeParams.objectId?
      showCard $routeParams.objectId
  ]
