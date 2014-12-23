angular.module("PollerrApp")
   .filter('labelCase', function () {
      return function (input) {
          input = input.replace(/([A-Z])/g, ' $1');
          input = input.replace(/_/g, ' ');
          return input[0].toUpperCase() + input.slice(1);
      };
  })
 .filter('camelCase', function () {
    return function (input) {
      return input.toLowerCase().replace(/ (\w)/g, function (match, letter) {
        return letter.toUpperCase();
      });
    };
  })