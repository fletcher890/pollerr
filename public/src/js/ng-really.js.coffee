###*
A generic confirmation for risky actions.
Usage: Add attributes: ng-really-message="Are you sure"? ng-really-click="takeAction()" function
###
angular.module("PollerrApp").directive "ngReallyClick", [->
  restrict: "A"
  link: (scope, element, attrs) ->
    element.bind "click", ->
      message = attrs.ngReallyMessage
      scope.$apply attrs.ngReallyClick  if message and confirm(message)
      return

    return
]
angular.module("PollerrApp").run [
  "$route"
  "$rootScope"
  "$location"
  ($route, $rootScope, $location) ->
    original = $location.path
    $location.path = (path, reload) ->
      if reload is false
        lastRoute = $route.current
        un = $rootScope.$on("$locationChangeSuccess", ->
          $route.current = lastRoute
          un()
          return
        )
      original.apply $location, [path]
]