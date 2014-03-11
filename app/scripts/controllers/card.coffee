'use strict'

angular.module('tnkCardboxApp')
  .controller 'CardCtrl', ['$scope', '$location', '$routeParams', 'coreService', 'cardService', 'cardAttribute', ($scope, $location, $routeParams, coreService, cardService, cardAttribute) ->

    if !Parse.User.current()
      coreService.logout()
      return

    $scope.regions = cardAttribute.regions.concat(cardAttribute.prefectures)
    $scope.cardTypes = cardAttribute.cardTypes
    $scope.rarities = cardAttribute.rarities2
    $scope.skillEffectTypes = cardAttribute.skillEffectTypes
    $scope.skillEffectSigns = cardAttribute.skillEffectSigns
    $scope.card = {}
    $scope.cardObject = {}
    $scope.processing = false
    $scope.errorMessage = ''
    $scope.loading = false

    ###*
     * カード情報読み込み
    ###
    showCard = (objectId) ->
      $scope.loading = true
      cardService.getCardWithRefreshList(objectId, {
        success: (result) ->
          $scope.cardObject = result.object
          $scope.card = angular.copy result.object.attributes
          $scope.loading = false
        error: (error) ->
          $scope.loading = false
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
        $scope.cardObject = new Card()
        $scope.cardObject.setACL(new Parse.ACL(user))
        $scope.cardObject.set("user", user)
        #$scope.cardObject.set("cardId", cardService.guid())
        $scope.cardObject.set("extendLevel", 0)

      # 新規・変更 共通
      $scope.cardObject.set("name", $scope.card.name)
      $scope.cardObject.set("nameKana", $scope.card.nameKana)
      $scope.cardObject.set("rarity", $scope.card.rarity)
      $scope.cardObject.set("region", $scope.card.region)
      $scope.cardObject.set("level", $scope.card.level)
      $scope.cardObject.set("maxLevel", $scope.card.maxLevel)
      $scope.cardObject.set("cost", $scope.card.cost)
      $scope.cardObject.set("attack", $scope.card.attack)
      $scope.cardObject.set("defence", $scope.card.defence)
      $scope.cardObject.set("type", $scope.card.type)
      $scope.cardObject.set("skill", $scope.card.skill)
      $scope.cardObject.set("skillLevel", $scope.card.skillLevel)
      $scope.cardObject.set("skillName", $scope.card.skillName)
      $scope.cardObject.set("skillTarget", $scope.card.skillTarget)
      $scope.cardObject.set("skillEffectType", parseInt($scope.card.skillEffectType))
      $scope.cardObject.set("skillEffectRate", $scope.card.skillEffectRate)
      $scope.cardObject.set("skillEffectSign", parseInt($scope.card.skillEffectSign))

      $scope.cardObject.save(null, {
        success: (result) ->
          $scope.$apply( ->
            $scope.cardObject = result
            $scope.card = angular.copy result.attributes
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
