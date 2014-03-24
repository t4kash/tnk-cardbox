'use strict'

angular.module('tnkCardboxApp')
  .directive('textMatch', ($parse) ->
    require: 'ngModel'
    link: (scope, element, attrs, ctrl) ->
      ctrl.$parsers.unshift((viewValue) ->
        if viewValue == scope[attrs.textMatch]
          ctrl.$setValidity('mismatch', true)
          return viewValue
        else
          ctrl.$setValidity('mismatch', false)
          return undefined
      )
      #scope.$watch(
      #  () ->
      #    return $parse(attrs.textMatch)(scope) == ctrl.$modelValue
      #  (newValue, oldValue) ->
      #    ctrl.$setValidity('mismatch', newValue)
      #)
  )
