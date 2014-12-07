angular.module('PollerrApp', ['ngRoute', 'ngResource', 'ngMessages'])
  .config(function($routeProvider, $locationProvider) {
    
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

    $locationProvider.html5Mode(true);

  });