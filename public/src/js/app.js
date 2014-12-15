angular.module('PollerrApp', ['ngRoute', 'ngResource', 'ngMessages'])
  .config(function($routeProvider, $locationProvider, $httpProvider) {

    
    $routeProvider
      .when('/polls', {
        controller: 'PollsController',
        templateUrl: 'templates/polls/index.html'
      })
      .when('/polls/new', {
        controller: 'NewPollController', 
        templateUrl: 'templates/polls/new.html'
      })
      .when('/polls/:id', {
        controller: 'SinglePollController',
        templateUrl: 'templates/polls/edit.html'
      })

    $httpProvider.defaults.useXDomain = true;
    delete $httpProvider.defaults.headers.common["X-Requested-With"];         
    $locationProvider.html5Mode(true);

  });