var app;

app = angular.module("PollerrApp", ["ngRoute", "ngResource", "ngMessages", "ngCookies", "ngAnimate", "angular-flash.service", "angular-flash.flash-alert-directive", "ui.utils", "ui.bootstrap"]);

app.value("loggedIn", false);

app.config(function($routeProvider, $locationProvider, $httpProvider, flashProvider) {
  $routeProvider.when("/", {
    controller: "DashboardController",
    templateUrl: "templates/dashboard/index.html",
    auth: true
  }).when("/logout", {
    controller: "AuthController",
    template: ""
  }).when("/login", {
    controller: "AuthController",
    templateUrl: "templates/auth/login.html"
  }).when("/register", {
    controller: "AuthController",
    templateUrl: "templates/auth/register.html"
  }).when("/polls", {
    controller: "PollsController",
    templateUrl: "templates/polls/index.html",
    auth: true
  }).when("/polls/new", {
    controller: "NewPollController",
    templateUrl: "templates/polls/new.html",
    auth: true
  }).when("/polls/:id/edit", {
    controller: "EditPollController",
    templateUrl: "templates/polls/edit.html",
    auth: true
  }).when("/polls/:id/:tab?", {
    controller: "SinglePollController",
    templateUrl: "templates/polls/show.html",
    auth: true
  }).when("/polls/:id/questions/new", {
    controller: "NewQuestionController",
    templateUrl: "templates/questions/new.html",
    auth: true
  }).when("/polls/:id/questions/:qid/edit", {
    controller: "EditQuestionController",
    templateUrl: "templates/questions/edit.html",
    auth: true
  }).when("/take-survey/:username/:id", {
    controller: "TakePollController",
    templateUrl: "templates/poll-fe/index.html",
    auth: true
  }).when("/settings", {
    controller: "SettingsController",
    templateUrl: "templates/settings/index.html",
    auth: true
  });
  $httpProvider.defaults.useXDomain = true;
  delete $httpProvider.defaults.headers.common["X-Requested-With"];
  $locationProvider.html5Mode(true);
  flashProvider.errorClassnames.push("alert-danger");
});

app.run(function($location, $log, $rootScope, $route, $cookies, loggedIn) {
  $rootScope.$watch((function() {
    return $location.path();
  }), function(a) {
    var nextPath, nextRoute;
    nextPath = $location.path();
    nextRoute = $route.routes[nextPath];
    if (nextRoute && nextRoute.auth && String($cookies.loggedIn) === "false") {
      $location.path("/login");
    }
  });
});
