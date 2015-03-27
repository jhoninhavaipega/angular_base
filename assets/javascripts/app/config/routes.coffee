@app.config ($httpProvider, $routeProvider, $locationProvider, view_path)->

  # $locationProvider.html5Mode(true).hashPrefix('!')

  $httpProvider.interceptors.push('httpInterceptor')

  $routeProvider
    .when "/",
      templateUrl: "#{view_path}/home/index.html",
      controller: "HomeController",
      title: "Titulo"

    .when "/404",
      templateUrl: "#{view_path}/errors/404.html",
      controller: "ErrorController",
      title: "404"

    .otherwise
      redirectTo: "/404"
