'use strict'

TNK_CARD_APP_KEY = "a8f150d43aec60003889f014317dbbe73380925c62e72b4e672ff0ff6cc2326c"
TNK_CARD_CLIENT_KEY = "d48b3fb6162b5c0e06bca7047866a30e2fc8b85bc12a2d8f9a5a476d571e57cc"

NCMB.initialize(TNK_CARD_APP_KEY, TNK_CARD_CLIENT_KEY)


angular.module('tnkCardboxApp', [
  'ngRoute'
  'ngCsv'
])
  .config ['$routeProvider', ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/login.html'
        controller: 'LoginCtrl'
      .when '/main',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'
  ]

