angular.module('pollerApp')
  .factory('Poll', function($resource) {
    return $resource('/api/polls/:hash', { hash: '@id' }, {
      'update'	: { method: 'PUT', url: '/api/polls/', params: { hash: '@id'} }
    });
  });