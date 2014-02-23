'use strict'

angular.module('tnkCardboxApp')
  .service 'cardService', () ->

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

    @
