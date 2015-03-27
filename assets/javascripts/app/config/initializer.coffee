@app.constant "view_path", "public/views"
@app.constant "directive_view_path", "public/views/directives"

@app.run ($rootScope, $route)->
  $rootScope.$on "$routeChangeStart", (event, currRoute, prevRoute)->
    $rootScope.title = currRoute.title
