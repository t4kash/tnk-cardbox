'use strict'

angular.module('tnkCardboxApp')
  .controller 'LoginCtrl', ($scope, $location) ->

    if Parse.User.current()
      $location.path "/main"
      return

    $scope.processing = false

    # ログイン
    $scope.login = (form) ->
      if form.$invalid
        return

      $scope.processing = true

      Parse.User.logIn($scope.loginId, $scope.loginPassword, {
        success: (user) ->
          # 成功
          $scope.gotoMain()
        error: (user, error) ->
          # エラー
          console.log error
          if error.code == Parse.Error.OBJECT_NOT_FOUND
            alert "IDもしくはパスワードのエラー"
          else
            alert "ログインできません:" + error.code

          $scope.$apply( ->
            $scope.processing = false
          )
      })

    # 登録
    $scope.userRegistration = (form) ->
      if form.$invalid
        return

      if !confirm "ユーザー登録を行いますか？"
        return

      Parse.User.signUp($scope.loginId, $scope.loginPassword, { ACL: new Parse.ACL() }, {
        success: (user) ->
          # 成功
          $scope.gotoMain()
        error: (user, error) ->
          # エラー
          console.log error
          if error.code == Parse.Error.USERNAME_TAKEN
            alert "すでに使用されているIDです"
          else
            alert "登録エラー:" + error.code
      })

    # main画面へ
    $scope.gotoMain = ->
      $scope.$apply( ->
        $location.path "/main"
        $scope.processing = false
      )

