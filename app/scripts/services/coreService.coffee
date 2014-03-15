'use strict'

angular.module('tnkCardboxApp')
  .service 'coreService', ($rootScope, $location) ->

    ###*
     * Userオブジェクト
    ###
    this.getUser = ->
      return Parse.User.current()

    ###*
     * ログアウト
    ###
    this.logout = ->
      Parse.User.logOut()
      $location.path "/"

    ###*
     * ユーザー設定を取得
     * @param {Object} callback {success:function(userConfig), error:function(error)}
    ###
    this.getUserConfig = (callback) ->
      UserConfig = Parse.Object.extend "UserConfig"
      query = new Parse.Query UserConfig
      query.equalTo("user", this.getUser())

      query.first({
        success: (result) ->
          $rootScope.$apply( ->
            callback.success result
          )
        error: (error) ->
          console.log(error.code + ' ' + error.message)
          $rootScope.$apply( ->
            callback.error error
          )
      })

    ###*
     * 設定を保存する
     * @param {object} userConfig UserConfig object
     * @param {object} data values {"prefecture": prefecture}
     * @param {object} callback {success:function(result), error:function(error)}
    ###
    this.saveUserConfig = (userConfig, data, callback) ->

      if not userConfig?
        # 新規追加
        user = Parse.User.current()
        UserConfig = Parse.Object.extend("UserConfig")
        userConfig = new UserConfig()
        userConfig.setACL(new Parse.ACL(user))
        userConfig.set("user", user)

      # 新規・変更 共通
      for key, val of data
        userConfig.set(key, val)

      userConfig.save(null, {
        success: (result) ->
          $rootScope.$apply( ->
            callback.success result
          )
        error: (result, error) ->
          console.log error
          $rootScope.$apply( ->
            callback.error error
          )
      })


    @
