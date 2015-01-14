app = angular.module("PollerrApp", [
  "ngRoute"
  "ngResource"
  "ngMessages"
  "ngCookies"
  "angular-flash.service"
  "angular-flash.flash-alert-directive"
  "ui.utils"
  "ui.bootstrap"
])
app.value "loggedIn", false
app.config ($routeProvider, $locationProvider, $httpProvider, flashProvider) ->
  $routeProvider.when("/",
    controller: "DashboardController"
    templateUrl: "templates/dashboard/index.html"
    auth: true
  ).when("/logout",
    controller: "AuthController"
    template: ""
  ).when("/login",
    controller: "AuthController"
    templateUrl: "templates/auth/login.html"
  ).when("/register",
    controller: "AuthController"
    templateUrl: "templates/auth/register.html"
  ).when("/polls",
    controller: "PollsController"
    templateUrl: "templates/polls/index.html"
    auth: true
  ).when("/polls/new",
    controller: "NewPollController"
    templateUrl: "templates/polls/new.html"
    auth: true
  ).when("/polls/:id/edit",
    controller: "EditPollController"
    templateUrl: "templates/polls/edit.html"
    auth: true
  ).when("/polls/:id/:tab?",
    controller: "SinglePollController"
    templateUrl: "templates/polls/show.html"
    auth: true
  ).when("/polls/:id/questions/new",
    controller: "NewQuestionController"
    templateUrl: "templates/questions/new.html"
    auth: true
  ).when("/polls/:id/questions/:qid/edit",
    controller: "EditQuestionController"
    templateUrl: "templates/questions/edit.html"
    auth: true
  ).when("/take-survey/:username/:id",
    controller: "TakePollController"
    templateUrl: "templates/poll-fe/index.html"
    auth: true
  ).when "/settings",
    controller: "SettingsController"
    templateUrl: "templates/settings/index.html"
    auth: true

  $httpProvider.defaults.useXDomain = true
  delete $httpProvider.defaults.headers.common["X-Requested-With"]

  $locationProvider.html5Mode true
  flashProvider.errorClassnames.push "alert-danger"
  return

app.run ($location, $log, $rootScope, $route, $cookies, loggedIn) ->
  $rootScope.$watch (->
    $location.path()
  ), (a) ->
    nextPath = $location.path()
    nextRoute = $route.routes[nextPath]
    $location.path "/login"  if nextRoute and nextRoute.auth and String($cookies.loggedIn) is "false"
    return

  return
