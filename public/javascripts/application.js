this.app = angular.module('app', ['ngRoute', 'ngResource']);

this.app.factory('httpInterceptor', function($q, $location) {
  return {
    response: function(response) {
      return response || $q.when(response);
    },
    responseError: function(response) {
      if (response.status === 404) {
        return $location.path('/404');
      }
    }
  };
});

this.app.constant("view_path", "public/views");

this.app.constant("directive_view_path", "public/views/directives");

this.app.run(function($rootScope, $route) {
  return $rootScope.$on("$routeChangeStart", function(event, currRoute, prevRoute) {
    return $rootScope.title = currRoute.title;
  });
});

this.app.config(function($httpProvider, $routeProvider, $locationProvider, view_path) {
  $httpProvider.interceptors.push('httpInterceptor');
  return $routeProvider.when("/", {
    templateUrl: view_path + "/home/index.html",
    controller: "HomeController",
    title: "Titulo"
  }).when("/404", {
    templateUrl: view_path + "/errors/404.html",
    controller: "ErrorController",
    title: "404"
  }).otherwise({
    redirectTo: "/404"
  });
});

this.app.controller("ErrorController", function($rootScope, $scope) {
  return console.log('init controller error');
});

this.app.controller("HomeController", function($rootScope, $scope) {
  return console.log('init controller home');
});

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImFwcC5jb2ZmZWUiLCJjb25maWcvaHR0cF9pbnRlcmNlcHRvci5jb2ZmZWUiLCJjb25maWcvaW5pdGlhbGl6ZXIuY29mZmVlIiwiY29uZmlnL3JvdXRlcy5jb2ZmZWUiLCJhcHAvY29udHJvbGxlcnMvZXJyb3JfY29udHJvbGxlci5jb2ZmZWUiLCJhcHAvY29udHJvbGxlcnMvaG9tZV9jb250cm9sbGVyLmNvZmZlZSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUFBQSxJQUFBLENBQUEsR0FBQSxHQUFBLE9BQUEsQ0FBQSxNQUFBLENBQUEsS0FBQSxFQUFBLENBQUEsU0FBQSxFQUFBLFlBQUEsQ0FBQSxDQUFBLENBQUE7O0FBQUEsSUNBQSxDQUFBLEdBQUEsQ0FBQSxPQUFBLENBQUEsaUJBQUEsRUFBQSxTQUFBLEVBQUEsRUFBQSxTQUFBLEdBQUE7U0FDQTtBQUFBLElBQUEsUUFBQSxFQUFBLFNBQUEsUUFBQSxHQUFBO2FBQ0EsUUFBQSxJQUFBLEVBQUEsQ0FBQSxJQUFBLENBQUEsUUFBQSxFQURBO0lBQUEsQ0FBQTtBQUFBLElBR0EsYUFBQSxFQUFBLFNBQUEsUUFBQSxHQUFBO0FBQ0EsTUFBQSxJQUFBLFFBQUEsQ0FBQSxNQUFBLEtBQUEsR0FBQTtlQUNBLFNBQUEsQ0FBQSxJQUFBLENBQUEsTUFBQSxFQURBO09BREE7SUFBQSxDQUhBO0lBREE7QUFBQSxDQUFBLENEQUEsQ0FBQTs7QUFBQSxJRUFBLENBQUEsR0FBQSxDQUFBLFFBQUEsQ0FBQSxXQUFBLEVBQUEsY0FBQSxDRkFBLENBQUE7O0FBQUEsSUVDQSxDQUFBLEdBQUEsQ0FBQSxRQUFBLENBQUEscUJBQUEsRUFBQSx5QkFBQSxDRkRBLENBQUE7O0FBQUEsSUVHQSxDQUFBLEdBQUEsQ0FBQSxHQUFBLENBQUEsU0FBQSxVQUFBLEVBQUEsTUFBQSxHQUFBO1NBQ0EsVUFBQSxDQUFBLEdBQUEsQ0FBQSxtQkFBQSxFQUFBLFNBQUEsS0FBQSxFQUFBLFNBQUEsRUFBQSxTQUFBLEdBQUE7V0FDQSxVQUFBLENBQUEsS0FBQSxHQUFBLFNBQUEsQ0FBQSxNQURBO0VBQUEsQ0FBQSxFQURBO0FBQUEsQ0FBQSxDRkhBLENBQUE7O0FBQUEsSUdBQSxDQUFBLEdBQUEsQ0FBQSxNQUFBLENBQUEsU0FBQSxhQUFBLEVBQUEsY0FBQSxFQUFBLGlCQUFBLEVBQUEsU0FBQSxHQUFBO0FBSUEsRUFBQSxhQUFBLENBQUEsWUFBQSxDQUFBLElBQUEsQ0FBQSxpQkFBQSxDQUFBLENBQUE7U0FFQSxjQUNBLENBQUEsSUFEQSxDQUNBLEdBREEsRUFFQTtBQUFBLElBQUEsV0FBQSxFQUFBLFNBQUEsR0FBQSxrQkFBQTtBQUFBLElBQ0EsVUFBQSxFQUFBLGdCQURBO0FBQUEsSUFFQSxLQUFBLEVBQUEsUUFGQTtHQUZBLENBTUEsQ0FBQSxJQU5BLENBTUEsTUFOQSxFQU9BO0FBQUEsSUFBQSxXQUFBLEVBQUEsU0FBQSxHQUFBLGtCQUFBO0FBQUEsSUFDQSxVQUFBLEVBQUEsaUJBREE7QUFBQSxJQUVBLEtBQUEsRUFBQSxLQUZBO0dBUEEsQ0FXQSxDQUFBLFNBWEEsQ0FZQTtBQUFBLElBQUEsVUFBQSxFQUFBLE1BQUE7R0FaQSxFQU5BO0FBQUEsQ0FBQSxDSEFBLENBQUE7O0FBQUEsSUlBQSxDQUFBLEdBQUEsQ0FBQSxVQUFBLENBQUEsaUJBQUEsRUFBQSxTQUFBLFVBQUEsRUFBQSxNQUFBLEdBQUE7U0FDQSxPQUFBLENBQUEsR0FBQSxDQUFBLHVCQUFBLEVBREE7QUFBQSxDQUFBLENKQUEsQ0FBQTs7QUFBQSxJS0FBLENBQUEsR0FBQSxDQUFBLFVBQUEsQ0FBQSxnQkFBQSxFQUFBLFNBQUEsVUFBQSxFQUFBLE1BQUEsR0FBQTtTQUNBLE9BQUEsQ0FBQSxHQUFBLENBQUEsc0JBQUEsRUFEQTtBQUFBLENBQUEsQ0xBQSxDQUFBIiwiZmlsZSI6ImFwcGxpY2F0aW9uLmpzIiwic291cmNlUm9vdCI6Ii9zb3VyY2UvIiwic291cmNlc0NvbnRlbnQiOlsiQGFwcCA9IGFuZ3VsYXIubW9kdWxlICdhcHAnLCBbJ25nUm91dGUnLCAnbmdSZXNvdXJjZSddXG4iLCJAYXBwLmZhY3RvcnkgJ2h0dHBJbnRlcmNlcHRvcicsICggJHEsICRsb2NhdGlvbiApLT5cbiAgcmVzcG9uc2U6ICggcmVzcG9uc2UgKS0+XG4gICAgcmVzcG9uc2UgfHwgJHEud2hlbiggcmVzcG9uc2UgKVxuXG4gIHJlc3BvbnNlRXJyb3I6ICggcmVzcG9uc2UgKS0+XG4gICAgaWYgcmVzcG9uc2Uuc3RhdHVzID09IDQwNFxuICAgICAgJGxvY2F0aW9uLnBhdGgoJy80MDQnKVxuIiwiQGFwcC5jb25zdGFudCBcInZpZXdfcGF0aFwiLCBcInB1YmxpYy92aWV3c1wiXG5AYXBwLmNvbnN0YW50IFwiZGlyZWN0aXZlX3ZpZXdfcGF0aFwiLCBcInB1YmxpYy92aWV3cy9kaXJlY3RpdmVzXCJcblxuQGFwcC5ydW4gKCRyb290U2NvcGUsICRyb3V0ZSktPlxuICAkcm9vdFNjb3BlLiRvbiBcIiRyb3V0ZUNoYW5nZVN0YXJ0XCIsIChldmVudCwgY3VyclJvdXRlLCBwcmV2Um91dGUpLT5cbiAgICAkcm9vdFNjb3BlLnRpdGxlID0gY3VyclJvdXRlLnRpdGxlXG4iLCJAYXBwLmNvbmZpZyAoJGh0dHBQcm92aWRlciwgJHJvdXRlUHJvdmlkZXIsICRsb2NhdGlvblByb3ZpZGVyLCB2aWV3X3BhdGgpLT5cblxuICAjICRsb2NhdGlvblByb3ZpZGVyLmh0bWw1TW9kZSh0cnVlKS5oYXNoUHJlZml4KCchJylcblxuICAkaHR0cFByb3ZpZGVyLmludGVyY2VwdG9ycy5wdXNoKCdodHRwSW50ZXJjZXB0b3InKVxuXG4gICRyb3V0ZVByb3ZpZGVyXG4gICAgLndoZW4gXCIvXCIsXG4gICAgICB0ZW1wbGF0ZVVybDogXCIje3ZpZXdfcGF0aH0vaG9tZS9pbmRleC5odG1sXCIsXG4gICAgICBjb250cm9sbGVyOiBcIkhvbWVDb250cm9sbGVyXCIsXG4gICAgICB0aXRsZTogXCJUaXR1bG9cIlxuXG4gICAgLndoZW4gXCIvNDA0XCIsXG4gICAgICB0ZW1wbGF0ZVVybDogXCIje3ZpZXdfcGF0aH0vZXJyb3JzLzQwNC5odG1sXCIsXG4gICAgICBjb250cm9sbGVyOiBcIkVycm9yQ29udHJvbGxlclwiLFxuICAgICAgdGl0bGU6IFwiNDA0XCJcblxuICAgIC5vdGhlcndpc2VcbiAgICAgIHJlZGlyZWN0VG86IFwiLzQwNFwiXG4iLCJAYXBwLmNvbnRyb2xsZXIgXCJFcnJvckNvbnRyb2xsZXJcIiwgKCRyb290U2NvcGUsICRzY29wZSktPlxuICBjb25zb2xlLmxvZyAnaW5pdCBjb250cm9sbGVyIGVycm9yJ1xuIiwiQGFwcC5jb250cm9sbGVyIFwiSG9tZUNvbnRyb2xsZXJcIiwgKCRyb290U2NvcGUsICRzY29wZSktPlxuICBjb25zb2xlLmxvZyAnaW5pdCBjb250cm9sbGVyIGhvbWUnXG4iXX0=