angular.module('PollerrApp')
  .controller('PollsController', function ($scope, $rootScope, Poll, $location) {
    $rootScope.PAGE = '/polls'
    $scope.polls = Poll.query();
    $scope.fields = ['title']

    $scope.sort = function(field) {
      $scope.sort.field = field;
      $scope.sort.order = !$scope.sort.order;
    }

    $scope.sort.field = 'title';
    $scope.sort.order = false;

    $scope.show = function(id) {
      $location.url('polls/' + id);
    };

    $scope.new = function() {
      $location.url('polls/new')
    }

  })

  .controller('NewPollController', function ($scope, $rootScope, Poll, $location) {
    $rootScope.PAGE = '/polls/new';
    $scope.poll = new Poll({
      title: ''
    });

    $scope.save = function() {

      if($scope.newPoll.$invalid) {
        $scope.$broadcast('record:invalid');
      } else {
        $scope.poll.$save();
        $location.url('/polls');
      }

    };

  })

  .controller('SinglePollController', function ($scope, $rootScope, $location, Poll, $routeParams) {
    $rootScope.PAGE = '/polls/:id'
    console.log('123123123');
    $scope.poll = Poll.get({ id: $routeParams.id });

    $scope.edit = function(id) {
      $location.url('polls/' + id + '/edit');
    }

    $scope.delete = function () {
      $scope.poll.$delete();
      $location.url('/polls');
    }

  })

  .controller('EditPollController', function($scope, $rootScope, $location, Poll, $routeParams) {
    $rootScope.PAGE = '/polls/:id/edit'
    $scope.poll = Poll.get({ id: $routeParams.id });

    $scope.save = function() {
      $scope.poll.$update();
      // $location.url('/polls');
    }
  });