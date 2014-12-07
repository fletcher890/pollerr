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

  })

  .controller('NewPollController', function ($scope, $rootScope, Poll, $location) {
    $rootScope.PAGE = '/polls/new';
    $scope.poll = new Poll({
      title: ['', 'text']
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

  .controller('SinglePollController', function($scope, $rootScope, $location, Poll, $routeParams) {
    $rootScope.PAGE = '/polls/:id'
    $scope.poll = Poll.get({ id: parseInt($routeParams.id, 10) });
  });