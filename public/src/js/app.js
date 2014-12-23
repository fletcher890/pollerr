angular.module('PollerrApp', ['ngRoute', 'ngResource', 'ngMessages', 'angular-flash.service', 'angular-flash.flash-alert-directive', 'ui.utils', 'ui.bootstrap', 'summernote'])
  .config(function($routeProvider, $locationProvider, $httpProvider, flashProvider) {
    
    $routeProvider
      .when('/', {
        templateUrl: 'templates/dashboard/index.html'
      })
      .when('/polls', {
        controller: 'PollsController',
        templateUrl: 'templates/polls/index.html'
      })
      .when('/polls/new', {
        controller: 'NewPollController', 
        templateUrl: 'templates/polls/new.html'
      })
      .when('/polls/:id/edit', {
        controller: 'EditPollController',
        templateUrl: 'templates/polls/edit.html'
      })
      .when('/polls/:id/:tab?', {
        controller: 'SinglePollController',
        templateUrl: 'templates/polls/show.html'
      })
      .when('/polls/:id/questions/new', {
        controller: 'NewQuestionController',
        templateUrl: 'templates/questions/new.html'
      })
      .when('/polls/:id/questions/:qid/edit', {
        controller: 'EditQuestionController',
        templateUrl: 'templates/questions/edit.html'
      })
      .when('/take-survey/:username/:id', {
        controller: 'TakePollController',
        templateUrl: 'templates/poll-fe/index.html'
      })
      .when('/settings', {
        controller: 'SettingsController',
        templateUrl: 'templates/settings/index.html'
      })

    $httpProvider.defaults.useXDomain = true;
    delete $httpProvider.defaults.headers.common["X-Requested-With"];         
    $locationProvider.html5Mode(true);

    flashProvider.errorClassnames.push('alert-danger');

  });