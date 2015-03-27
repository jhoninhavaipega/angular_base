@app.factory 'httpInterceptor', ( $q, $location )->
  response: ( response )->
    response || $q.when( response )

  responseError: ( response )->
    if response.status == 404
      $location.path('/404')
