'use strict'

angular.module('tnkCardboxApp')
  .controller 'LoginCtrl', ($scope, $location) ->

    if NCMB.User.current()
      $location.path "/main"
      return

    $scope.processing = false

    # ログイン
    $scope.login = (form) ->
      if form.$invalid
        return

      $scope.processing = true

      NCMB.User.logIn($scope.loginId, $scope.loginPassword, {
        success: (user) ->
          # 成功
          $scope.gotoMain()
        error: (user, error) ->
          # エラー
          console.log error
          if error.code == 'E401002'
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

      user = new NCMB.User()
      user.set("userName", $scope.loginId)
      user.set("password", $scope.loginPassword)
      #user.set("mailAddress", "email@example.com")

      user.signUp(null, {
        success: (user) ->
          # 成功
          $scope.gotoMain()
        error: (user, error) ->
          # エラー
          console.log error
          if error.code == 'E409001'
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

