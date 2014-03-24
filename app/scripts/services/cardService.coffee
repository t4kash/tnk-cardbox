'use strict'

angular.module('tnkCardboxApp')
  .service 'cardService', ($rootScope) ->

    ###*
     * 全カードデータ取得
    ###
    this.findCardList = (callback) ->
      Card = Parse.Object.extend "Card"
      query = new Parse.Query Card
      query.limit 1000
      query.equalTo("user", Parse.User.current())

      query.find callback

    ###*
     * カードデータ取得
     * @param {array} ids id list
    ###
    this.findCardListInIds = (ids, callback) ->
      Card = Parse.Object.extend "Card"
      query = new Parse.Query Card
      query.limit 1000
      query.equalTo("user", Parse.User.current())
      query.containedIn("objectId", ids)

      query.find callback

    ###*
     * objectIdを指定してカード情報1件取得
     * @param {string} objectId object id
     * @param {Object} callback {success:function, error:function}
    ###
    this.getCard = (objectId, callback) ->
      Card = Parse.Object.extend "Card"
      query = new Parse.Query Card
      query.equalTo("user", Parse.User.current())

      query.get(objectId, callback)

    ###*
     * カードリストにカード情報を1件追加する
     * @param {object} cardObject カード情報
    ###
    pushCard = (cardObject) ->
      card = angular.copy cardObject.attributes
      #card.object = cardObject
      card.selected = false
      card.id = cardObject.id
      $rootScope.cards.push card
      $rootScope.cardObjects.push cardObject

    ###*
     * 全カードデータを取得して$rootScopeに格納する
     * @param {object} callback {success:function(), error:function(error)}
     * @param {bool} force true:force refresh false:optimize
    ###
    this.refreshCardList = (callback, force) ->

      if force is undefined
        force = false

      if !force && $rootScope.cards?
        callback.success()
        return

      $rootScope.cards = []
      $rootScope.cardObjects = []

      this.findCardList({
        success: (results) ->
          console.log "total: " + results.length
          $rootScope.$apply( ->
            $rootScope.cards = []
            $rootScope.cardObjects = []

            for result in results
              pushCard result

            callback.success()
          )
        error: (error) ->
          console.log(error.code + ' ' + error.message)
          $rootScope.$apply( ->
            callback.error error
          )
      })

    ###*
     * 読み込み済みのカードリストから指定のカード情報を返す
     * @param {string} objectId カード情報のobject id
     * @return {object} カード情報。存在しない場合はnullを返す
    ###
    this.getCardFromMemory = (objectId) ->
      for card, i in $rootScope.cards
        if card.id == objectId
          ret = angular.copy card
          ret.object = $rootScope.cardObjects[i]
          return ret

      return null

    ###*
     * objectIdを指定してカード情報1件取得
     * カードリスト情報を取得していない場合は取得する
     * @param {string} objectId object id
     * @param {Object} callback {success:function, error:function}
    ###
    this.getCardWithRefreshList = (objectId, callback) ->
      getFunc = this.getCardFromMemory
      this.refreshCardList({
        success: () ->
          callback.success(getFunc objectId)
        error: (error) ->
          callback.error error
      })

    ###*
     * random
    ###
    s4 = ->
      return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1)

    ###*
     * カードID用のUUID生成
     * @return {string} GUID
    ###
    this.guid = ->
      return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4()

    ###*
     * 更新したカードをカードリストに反映させる
     * @param {object} cardObject カード情報
    ###
    this.updatedCard = (cardObject) ->
      for card, i in $rootScope.cards
        if card.id == cardObject.id
          $rootScope.cards[i] = angular.copy cardObject.attributes
          $rootScope.cards[i].id = cardObject.id
          $rootScope.cardObjects[i] = cardObject
          return

      pushCard cardObject

    @
