angular.module('PollerrApp')
  .factory('Poll', function($resource) {
    return $resource('/api/polls', { id: '@id' }, {
      'update': { method: 'PUT' }
    });
  });