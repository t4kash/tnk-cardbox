'use strict'

angular.module('tnkCardboxApp')
  .controller 'CardCtrl', ['$scope', '$location', '$routeParams', 'cardService', 'cardAttribute', ($scope, $location, $routeParams, cardService, cardAttribute) ->

    $scope.regions = cardAttribute.regions.concat(cardAttribute.prefectures)
    $scope.cardTypes = cardAttribute.cardTypes
    $scope.rarities = cardAttribute.rarities2
    $scope.item = {}
    $scope.cardObject = {}
    $scope.processing = false
    $scope.errorMessage = ''
    $scope.loading = false

    ###*
     * random
    ###
    s4 = ->
      return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1)

    ###*
     * Generate GUID
    ###
    guid = ->
      return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4()

    ###*
     * カード情報読み込み
    ###
    showCard = (objectId) ->
      $scope.loading = true
      cardService.getCard(objectId, {
        success: (result) ->
          $scope.$apply( ->
            $scope.cardObject = result
            $scope.item = angular.copy result.attributes
            $scope.loading = false
          )
        error: (result, error) ->
          console.log error
          $scope.$apply( ->
            $scope.loading = false
          )
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
        $scope.cardObject.set("cardId", guid())
        $scope.cardObject.set("extendLevel", 0)

      # 新規・変更 共通
      $scope.cardObject.set("name", $scope.item.name)
      $scope.cardObject.set("nameKana", $scope.item.nameKana)
      $scope.cardObject.set("rarity", $scope.item.rarity)
      $scope.cardObject.set("region", $scope.item.region)
      $scope.cardObject.set("level", $scope.item.level)
      $scope.cardObject.set("maxLevel", $scope.item.maxLevel)
      $scope.cardObject.set("cost", $scope.item.cost)
      $scope.cardObject.set("attack", $scope.item.attack)
      $scope.cardObject.set("defence", $scope.item.defence)
      $scope.cardObject.set("type", $scope.item.type)
      $scope.cardObject.set("skill", $scope.item.skill)
      $scope.cardObject.set("skillLevel", $scope.item.skillLevel)
      $scope.cardObject.set("skillName", $scope.item.skillName)
      $scope.cardObject.set("skillTarget", $scope.item.skillTarget)

      $scope.cardObject.save(null, {
        success: (result) ->
          $scope.$apply( ->
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
