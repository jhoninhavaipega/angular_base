@intimusApp = angular.module 'intimusApp', ['ngRoute', 'ngResource']
@intimusApp.controller "CalendarioMenstrualController", ($rootScope, $scope)->

  $scope.animate = ->
    setTimeout ->

      sequence = new Sequence
        images: ['CALENDARIO_0.png', 'CALENDARIO_1.png', 'CALENDARIO_2.png', 'CALENDARIO_3.png','CALENDARIO_4.png','CALENDARIO_5.png','CALENDARIO_6.png','CALENDARIO_7.png','CALENDARIO_8.png','CALENDARIO_9.png','CALENDARIO_10.png','CALENDARIO_11.png','CALENDARIO_12.png','CALENDARIO_13.png','CALENDARIO_14.png','CALENDARIO_15.png','CALENDARIO_16.png','CALENDARIO_17.png','CALENDARIO_18.png','CALENDARIO_19.png','CALENDARIO_20.png','CALENDARIO_21.png','CALENDARIO_22.png','CALENDARIO_23.png','CALENDARIO_24.png','CALENDARIO_25.png','CALENDARIO_26.png','CALENDARIO_27.png','CALENDARIO_28.png']
        path: 'public/images/sequence-calendar/'
        target: $('.sequence-calendar')
        complete: () ->
          console.log 'complete'

      TweenMax.to $('.container-article'), 0.6, { css:{ opacity: '1' }, ease: Expo.easeOut, onComplete: ->
        TweenMax.to $('.container-header'), 0.6, { css:{ 'margin-top': '0' }, ease: Expo.easeOut }
        TweenMax.to $('.show-finish-animate'), 0.5, { css:{ 'opacity': '1' }, delay: 0.4, ease: Expo.easeOut, onStart: ->
          sequence.play()
        }
        TweenMax.to $('.main-article'), 0.9, { css:{ opacity: '1', 'margin-top': '0' }, ease: Expo.easeOut, onComplete: ->
          TweenMax.to $('.box-animate-calendar img'), 0.3, { css:{ rotation: 90 }, ease: Expo.easeOut }
          TweenMax.to $('.box-animate-calendar'), 0.3, { css:{ opacity: '0' }, delay: 0.2, ease: Expo.easeOut, onComplete: ->
            $('.box-animate-calendar').hide()
          }

          TweenMax.to $('.cadastrado .bg-icon'), 0.4, { css:{ 'top': '0', opacity: '1', scale: '1' }, ease: Expo.easeOut, delay: 1 }
          TweenMax.to $('.cadastrado h2'), 0.4, { css:{ 'top': '0', opacity: '1' }, ease: Expo.easeOut, delay: 0.9 }
          TweenMax.to $('.cadastrado p'), 0.4, { css:{ 'top': '0', opacity: '1' }, ease: Expo.easeOut, delay: 0.8 }
          TweenMax.to $('.cadastrado a'), 0.4, { css:{ 'top': '0', opacity: '1' }, ease: Expo.easeOut, delay: 0.7 }

          TweenMax.to $('.cadastrar .bg-icon'), 0.4, { css:{ 'top': '0', opacity: '1', scale: '1' }, ease: Expo.easeOut, delay: 1.2 }
          TweenMax.to $('.cadastrar h2'), 0.4, { css:{ 'top': '0', opacity: '1' }, ease: Expo.easeOut, delay: 1.1 }
          TweenMax.to $('.cadastrar p'), 0.4, { css:{ 'top': '0', opacity: '1' }, ease: Expo.easeOut, delay: 1 }
          TweenMax.to $('.cadastrar a'), 0.4, { css:{ 'top': '0', opacity: '1' }, ease: Expo.easeOut, delay: 0.95 }
        }
      }

    , 200

@intimusApp.controller "CoisasDeMulherController", ($compile, $rootScope, $scope, $route, $location, WomensThings)->
  $rootScope.womensThingsNews = []
  $scope.page = 1
  $scope.per_page = 10
  $scope.is_last_page = false
  $scope.clicked = false

  $scope.animateMenu = ->
    TweenMax.to $('.menu-womens-things'), 0.6, { css:{ 'margin-top': '0', opacity: '1' }, ease: Expo.easeOut, onComplete: ->

      restore = 'Procure os conteúdos'

      $('#search-field').on 'focus', ->
        unless $(this).val() == ''
          $(this).val('').attr('placeholder', '')

      $('#search-field').on 'blur', ->
        if $(this).val() == ''
          $(this).val(restore).attr('placeholder', restore)
    }

  $scope.animateGrid = ->
    $('.grid-gradient li').each (index, item) ->
      TweenMax.to $('.grid-gradient li').eq(index), 0.2, { css:{ opacity: '1', scale: '1' }, ease: Expo.easeOut, delay: index * 0.1 }

  $scope.filterCategory = ( category_id )->
    $('.loader-coisas-de-mulher').show()
    $('.grid-gradient li').remove()
    $location.$$search = {}
    $scope.getArticles( category_id )

  $scope.hideSocial = ->
    $('.mask, .close-content-social').off 'click'
    $('.mask, .close-content-social').on 'click', ->
      $('.mask, .content-social').fadeOut 'fast'

  $scope.showSocial = ->
    $('.tapa-buraco').off 'click'
    $('.tapa-buraco').on 'click', ->
      post = $(this)
      classFake = post.data('class')
      social = post.data('social')
      title = post.data('social-title')
      content = post.data('social-content')

      $('.content-social header h2').text social
      $('.content-social section').html content

      $('.content-social').removeClass("content-social-0 content-social-1")
      $('.content-social').addClass("content-social-#{classFake}")

      $('.mask, .content-social').fadeIn 'fast', ->

        if classFake == 0
          $('.content-social section img[alt="COMMENTS:"]').replaceWith """ <span>COMMENTS:</span> """

          $('.content-social section p:eq(3)').css
            'border-top': '1px solid #cac8c9'
            'height': '69px'
            'line-height': '69px'
            'width': '100%'
            'position': 'absolute'
            'left': '0'
            'bottom': '0'

        $scope.hideSocial()

  $scope.getSocial = ( callback )->
    $('.grid-gradient').dpSocialTimeline
      feeds:
        facebook_page:
          data: '194584543896006',
          limit: 50

        instagram:
          data: 'intimusoficial',
          limit: 50

    , callback

  $scope.search = ->
    $location.search('q', $scope.query)

  $scope.getCategories = ->
    WomensThings.query { action: 'categories' }, (response)->
      $scope.categories = response
      $scope.$on 'ngRepeatFinished', (ngRepeatFinishedEvent)->
        if $('body').hasClass 'desktop'
          setTimeout ->
            $scope.animateMenu()
          , 200
        else
          $scope.animationMobile()

  $scope.getArticles = ( category_id )->
    query = null

    if $location.search().q
      query = { page: 1, q: $location.search().q }
    else if category_id
      query = { page: 1, category_id: category_id }
    else
      query = { page: 1 }

    query.per_page = $scope.per_page

    WomensThings.query query, (response, header)->
      $rootScope.womensThingsNews = response
      $scope.pagination = angular.fromJson(header('X-Pagination'))
      $scope.page = $scope.pagination.next_page
      $scope.is_last_page = $scope.pagination.is_last_page
      $scope.setGrid()

  $scope.setGrid = ->

    completePopulate = true

    $rootScope.gimmeMore = ->

      if $('body').hasClass 'mobile'
        $scope.clicked = true

      completePopulate = false
      WomensThings.query { page: $scope.page, per_page: $scope.per_page }, (response, header)->
        $scope.pagination = angular.fromJson(header('X-Pagination'))
        $scope.page = $scope.pagination.next_page
        $scope.is_last_page = $scope.pagination.is_last_page
        $('.tapa-buraco').remove()

        for highlight in response
          $rootScope.womensThingsNews.push highlight
          completePopulate = true

    $(window).on "scroll", (e) ->
      scrollHeight = $(document).height()
      scrollPosition = $(window).height() + $(window).scrollTop()

      if $('body').hasClass('mobile')
        if (((scrollHeight - scrollPosition) / scrollHeight) is 0) and ($location.path() == '/coisas-de-mulher') and completePopulate and !$scope.is_last_page and $scope.clicked
          $rootScope.gimmeMore()

      else
        if (((scrollHeight - scrollPosition) / scrollHeight) is 0) and ($location.path() == '/coisas-de-mulher') and completePopulate and !$scope.is_last_page
          $rootScope.gimmeMore()

    $scope.inch = 60
    $scope.space = 20
    $scope.packery = null

    $scope.fillSpace = (size) ->
      ($scope.inch * size) + ($scope.space * (size - 1))

    $scope.$on 'ngRepeatFinished', (ngRepeatFinishedEvent)->

      $scope.packery = new Packery(".desktop #grid", {
        itemSelector: "li"
        gutter: 20
      });

      if $('body').hasClass('desktop')

        $scope.getSocial ( posts )->
          facebook = _.where( posts, { name: 'facebook' } )
          instagram = _.where( posts, { name: 'instagram' } )

          count = 0

          for space in $scope.packery.packer.spaces

            if space.width < 960 and space.y < $('.grid-gradient').height()

              html = """ """

              alturaDoEspacoEmBranco = Math.min( space.height, $('.grid-gradient').height() - space.y )

              quantidadeDeQuadradosPorColuna = Math.abs(Math.floor( (space.width - 20) / 140 ))
              quantidadeDeQuadradosPorLinha = Math.abs(Math.floor( (alturaDoEspacoEmBranco - 20) / 140 ))

              quantidadeDeQuadradosPorLinha = if quantidadeDeQuadradosPorLinha == 0 then 1 else quantidadeDeQuadradosPorLinha

              quantidadeDeQuadrados = Math.abs(quantidadeDeQuadradosPorColuna * quantidadeDeQuadradosPorLinha)

              quebraLinha = 0
              quebraColuna = 0

              i = 0

              while i < quantidadeDeQuadrados

                top = space.y
                left = space.x

                if quantidadeDeQuadradosPorColuna < quantidadeDeQuadradosPorLinha
                  top = top + ( i * 160 )

                else
                  quebraLinha++  if i > 1 && i % quantidadeDeQuadradosPorColuna == 0
                  top = top + ( quebraLinha * 160 )

                  if quebraLinha > 0
                    left = left + ( (( (i + 1) - quebraLinha) - quantidadeDeQuadradosPorColuna) * 160 )

                  else
                    left = left + (i * 160)

                image_url = null

                if i % 2 == 0
                  contentSocial = instagram[count]
                  image_url = $($.parseHTML("<div>#{contentSocial.content}</div>")).find("img:eq(1)").attr("src")

                else
                  contentSocial = facebook[count - 1]
                  image_url = $($.parseHTML("<div>#{contentSocial.content}</div>")).find("img").attr("src")

                if image_url
                  image_url = image_url.replace("_s", "_n")
                  image_url = image_url.replace("p130x130/", "")
                  # image_url = image_url.replace("v/t1.0-9/", "")

                html += """ <li
                              class="tapa-buraco tapa-buraco-#{ i % 2 } index-#{i} space-#{space}"
                              data-class="#{ i % 2 }"
                              data-social='#{contentSocial.name}'
                              data-social-title='#{contentSocial.title}'
                              data-social-content='#{contentSocial.content}'
                              style="position: absolute; top: #{top}px; left: #{left}px; width: 140px; height: 140px; background-image: url(#{image_url}); background-size: cover;">
                              <img style="position: absolute; top: 50%; left: 50%; margin-left: -22px; margin-top: -22px;" src="public/images/icon-tapa-buraco-#{ i % 2 }.png" />
                            </li>
                        """

                i++
                count++

              $('.grid-gradient').append html
              $('.loader-coisas-de-mulher').hide()
              if $('body').hasClass 'desktop'
                setTimeout ->
                  $scope.animateGrid()
                , 200

              $scope.showSocial()

  $scope.animationMobile = ->
    $('.mobile .search-container input').attr('placeholder', '')

    $('body.mobile').off 'click'
    $('body.mobile').on 'click', ->
      $('#coisas-de-mulher-home .menu').removeClass 'show'

    $('.mobile .menu-trigger').off 'click'
    $('.mobile .menu-trigger').on 'click', ->

      unless $('.mobile .search-container').hasClass 'not-active'
        $('#coisas-de-mulher-home .menu').toggleClass 'show'

      else
        TweenMax.to $('.mobile .search-container'), 0.8, { css:{ 'width': '19%' } }
        TweenMax.to $('.menu-trigger'), 0.8, { css:{ 'width': '76.25%', 'padding-right': '20%' }, onStart: ->
          $('.mobile .search-container input').attr('placeholder', '')
          $('#search-field').removeClass 'small'

        , onComplete: ->
          $('#coisas-de-mulher-home .menu').addClass 'show'
          $('.mobile .search-container').removeClass 'not-active'
        }

      false

    $('.mobile .search-container').off 'click'
    $('.mobile .search-container').on 'click', ->

      unless $(this).hasClass 'not-active'
        $('#coisas-de-mulher-home .menu').removeClass 'show'
        $(this).addClass 'not-active'
        $('#search-field').addClass 'small'
        TweenMax.to $(this), 0.8, { css:{ 'width': '85%' } }
        TweenMax.to $('.menu-trigger'), 0.8, { css:{ 'width': '12.25%', 'padding-right': '0' }, onComplete: ->
          $('.mobile .search-container input').attr('placeholder', 'Procure os conteúdos')
        }

      false

@intimusApp.controller "CoisasDeMulherInternaController", ($rootScope, $scope, $sce, $routeParams, $location, WomensThings)->
  $scope.slug = $routeParams.slug
  $scope.article = {}
  $scope.url = $location.absUrl()

  $scope.showVideo = ->
    $('.media-wrapper iframe').hide()
    $('.media-wrapper img, .media-wrapper button').fadeOut(500, ->
      $('.media-wrapper iframe').fadeIn(500)
    )

  $scope.showArticle = ->
    $('.loader-interna-coisas-de-mulher').hide()
    TweenMax.to $('.show-content'), 0.6, { css:{ 'opacity': '1' }, ease: Expo.easeOut }

  $scope.getArticle = ->
    $('.loader-interna-coisas-de-mulher').show()
    WomensThings.get { slug: $routeParams.slug }, ( response )->
      $scope.article = response
      $scope.article.textHtml = $sce.trustAsHtml($scope.article.text)
      $scope.infoType = "info-#{$scope.article.type}-article" if $scope.article.content_type == "info"

@intimusApp.controller "ContatoController", ($rootScope, $scope, Contact)->

  $scope.addAnimation = ->
    sequence = new Sequence
      images: ['icon-header-contato_0.png', 'icon-header-contato_1.png', 'icon-header-contato_2.png', 'icon-header-contato_3.png', 'icon-header-contato_4.png', 'icon-header-contato_5.png', 'icon-header-contato_6.png', 'icon-header-contato_7.png', 'icon-header-contato_8.png', 'icon-header-contato_9.png', 'icon-header-contato_10.png']
      path: 'public/images/contato-sequencia/'
      target: $('.sequence-contato')
      loop: true
      FPS: 11

    sequence.play()

  $scope.sendContact = ->
    console.log $scope.contact
    # Contact.post $scope.contact

@intimusApp.controller "Error404Controller", ($rootScope, $scope, Error404)->

  $scope.getTags = ->
    Error404.query().$promise.then ( response )->
      $scope.tags = response

@intimusApp.controller "HomeController", ($rootScope, $scope)->

@intimusApp.controller "PoliticaDePrivacidadeController", ($rootScope, $scope)->
@intimusApp.controller "ProdutosController", ($rootScope, $scope, Products)->
  features = []
  animating = false
  openedStep3 = false
  actionFilter = false

  $scope.animateMenu = (callback)->
    if !openedStep3
      TweenMax.to $('.menu-products'), 0.8, { css:{ 'height': '244px', 'padding-bottom': '30px', 'padding-top': '26px' }, ease: Expo.easeOut }
      TweenMax.to $('.animation-menu-products img'), 1, { css:{ rotation: 90 }, delay: 0, ease: Expo.easeOut }
      TweenMax.to $('.animation-menu-products img'), 0.4, { css:{ opacity: '0' }, delay: 0.7, ease: Expo.easeOut, onComplete: ->
        $('.animation-menu-products').hide()
        callback()
        $('.menu-products').addClass 'init'
      }
    else
      callback()

  $scope.animateBox = ->
    $('.box-product').each (index, item)->
      TweenMax.to $('.box-product').eq(index), 0.2, { css:{ opacity: '1', scale: '1' }, ease: Expo.easeOut, delay: index * 0.05 }

  $scope.filterProduct = ( $event, parameters, btn )->

    unless actionFilter

      currentTarget = $event.currentTarget

      if $('body').hasClass 'desktop'

        actionFilter = true

        $('.box-product').each (index, item)->
          TweenMax.to $('.box-product').eq(index), 0.2, { css:{ opacity: '0', scale: '0.9' }, ease: Expo.easeOut, delay: index * 0.05 }

        setTimeout ->
          $scope.categories = []
          $('.loader-products').show()

          query = { category_id: parameters.category_id, sub_category_id: parameters.sub_category_id }

          unless parameters.sub_category_id
            features = []

          if parameters.feature_id

            quantity = features.length

            features = $.grep features, ( val )->
              return val != parameters.feature_id

            if quantity == features.length
              features.push( parameters.feature_id )

            if features.length > 0
              query.features = "#{features.toString()}"
            else
              delete query['features']

          Products.query(query).$promise.then ( response )->

            if $(currentTarget).hasClass 'category-of-products-step-1'

              unless animating

                animating = true

                unless $(currentTarget).parent().hasClass('active')

                  $('.desktop .category-of-products-step-3 .sub-categories-products li .active').removeClass 'selected'

                  # remove class
                  $('.category-of-products.active').removeClass('active')
                  $('.category-of-products.not-active').removeClass('not-active')
                  $('.desktop .category-of-products-step-2 li.active').removeClass('active')
                  $('.category-of-products-step-3 .sub-categories-products li').removeClass 'selected'

                  # add class
                  $(currentTarget).parent().addClass('active')
                  $('.category-of-products').not('.active').addClass('not-active')

                  # active
                  TweenMax.to $('.category-of-products.active'), 0.9, { css:{width: '860'}, onComplete: ->
                    animating = false
                    openedStep3 = false
                    actionFilter = false
                  }
                  TweenMax.to $('.category-of-products.active .category-of-products-step-1'), 0.35, { css:{opacity: '0', paddingLeft: '200px'}, onComplete: ->
                    $('.category-of-products.active .category-of-products-step-1').css('visibility', 'hidden')
                  }
                  TweenMax.to $('.category-of-products.active .category-of-products-step-2 h4'), 0.25, { css:{opacity: '1'}, delay: 0.15 }

                  if $(currentTarget).parent().hasClass('category-of-products-day-to-day')
                    TweenMax.to $('.category-of-products.active .category-of-products-step-2 li:nth-child(3)'), 0.25, { css:{opacity: '1'}, delay: 0.4 }
                    TweenMax.to $('.category-of-products.active .category-of-products-step-2 li:nth-child(2)'), 0.25, { css:{opacity: '1'}, delay: 0.55 }
                    TweenMax.to $('.category-of-products.active .category-of-products-step-2 li:nth-child(1)'), 0.25, { css:{opacity: '1'}, delay: 0.7 }

                  else
                    TweenMax.to $('.category-of-products.active .category-of-products-step-2 li:nth-child(1)'), 0.25, { css:{opacity: '1'}, delay: 0.4 }
                    TweenMax.to $('.category-of-products.active .category-of-products-step-2 li:nth-child(2)'), 0.25, { css:{opacity: '1'}, delay: 0.55 }
                    TweenMax.to $('.category-of-products.active .category-of-products-step-2 li:nth-child(3)'), 0.25, { css:{opacity: '1'}, delay: 0.7 }

                  # not-active
                  TweenMax.to $('.category-of-products.not-active .category-of-products-step-2 h4'), 0.25, { css:{opacity: '0'}, delay: 0.15 }
                  TweenMax.to $('.category-of-products.not-active .category-of-products-step-2 li:nth-child(1)'), 0.25, { css:{opacity: '0'}, delay: 0.4 }
                  TweenMax.to $('.category-of-products.not-active .category-of-products-step-2 li:nth-child(2)'), 0.25, { css:{opacity: '0'}, delay: 0.55 }
                  TweenMax.to $('.category-of-products.not-active .category-of-products-step-2 li:nth-child(3)'), 0.25, { css:{opacity: '0'}, delay: 0.7 }

                  TweenMax.to $('.category-of-products.not-active'), 0.6, { css:{height: '160px'}, onStart: ->
                    $('.menu-products').removeClass 'expand'
                  }
                  TweenMax.to $('.category-of-products.not-active .category-of-products-step-3'), 0.6, { css:{top: '0'}}
                  TweenMax.to $('.category-of-products.not-active'), 0.9, { css:{width: '60'}}
                  TweenMax.to $('.category-of-products.not-active .category-of-products-step-1'), 0.1, { css:{paddingRight: '0', opacity: '1'}, onStart: ->
                    $('.category-of-products.not-active .category-of-products-step-1').css 'visibility', 'visible'
                  }
                  TweenMax.to $('.category-of-products.not-active .category-of-products-step-1 h3'), 0.15, { css:{opacity: '0'} }
                  TweenMax.to $('.category-of-products.not-active .category-of-products-step-1 p'), 0.15, { css:{opacity: '0'} }
                  TweenMax.to $('.category-of-products.not-active .category-of-products-step-1 span'), 0.15, { css:{opacity: '0'}, onComplete: ->
                    $('.category-of-products.not-active .category-of-products-step-1').css
                      'padding-left': '0'
                      'padding-right': '0'

                    $('.category-of-products.not-active .category-of-products-step-1 .table').addClass 'style-animate'

                    $('.category-of-products.not-active .category-of-products-step-1 img').css
                      'width': '32px'
                  }
                  TweenMax.to $('.category-of-products.not-active .category-of-products-step-1 span'), 0.25, { css:{opacity: '1'}, delay: 0.85 }

            else if $(currentTarget).parent().parent().hasClass 'category-of-products-step-2'
              id = $(currentTarget).data('id')
              countFeatures = $(".category-of-products.active .category-of-products-step-3-#{id} .sub-categories-products").length
              $('.category-of-products-step-3 .sub-categories-products li').removeClass 'selected'

              if !animating and !openedStep3 and countFeatures > 0

                animating = true

                $('.desktop .category-of-products-step-2 li.active').removeClass('active')
                $(currentTarget).addClass('active')
                $(".category-of-products.active .category-of-products-step-3-#{id}").addClass('active')

                TweenMax.to $('.category-of-products.active'), 0.6, { css:{height: '+=117px'}, onStart: ->
                  $('.menu-products').addClass 'expand'
                }
                TweenMax.to $(".category-of-products.active .category-of-products-step-3-#{id}"), 0.6, { css:{top: '160px'}, onComplete: ->

                  animating = false
                  openedStep3 = true
                  actionFilter = false

                }

              else if openedStep3 and !animating and countFeatures > 0

                animating = true

                $('.desktop .category-of-products-step-2 li.active').removeClass('active')
                $(currentTarget).addClass('active')

                TweenMax.to $('.category-of-products.active'), 0.6, { css:{height: '-=117px'}, onStart: ->
                  $('.menu-products').removeClass 'expand'
                }
                TweenMax.to $(".category-of-products.active .category-of-products-step-3.active"), 0.6, { css:{top: '-160px'}, onComplete: ->

                  $(".category-of-products.active .category-of-products-step-3.active").removeClass('active')
                  $(".category-of-products.active .category-of-products-step-3-#{id}").addClass('active')

                  TweenMax.to $('.category-of-products.active'), 0.6, { css:{height: '+=117px'}, onStart: ->
                    $('.menu-products').addClass 'expand'
                  }
                  TweenMax.to $(".category-of-products.active .category-of-products-step-3-#{id}"), 0.6, { css:{top: '160px'}, onComplete: ->

                    animating = false
                    openedStep3 = true
                    actionFilter = false

                  }

                }

              else if !countFeatures > 0

                animating = true
                openedStep3 = false

                $('.desktop .category-of-products-step-2 li.active').removeClass('active')
                $(currentTarget).addClass('active')

                if $('.category-of-products.active').height() > 160

                  TweenMax.to $('.category-of-products.active'), 0.6, { css:{height: '-=117px'}, onStart: ->
                    $('.menu-products').removeClass 'expand'
                    animating = false
                    actionFilter = false
                  }

                else
                  actionFilter = false

            else if $(currentTarget).parent().parent().hasClass 'sub-categories-products'
              $(currentTarget).toggleClass 'selected'
              actionFilter = false

            else if $(currentTarget).hasClass 'back-to-select'

              unless animating

                animating = true

                # remove class
                $('.category-of-products.active').removeClass('active')
                $('.category-of-products.not-active').removeClass('not-active')
                $('.desktop .category-of-products-step-2 li.active').removeClass('active')
                $('.category-of-products-step-3 .sub-categories-products li').removeClass 'selected'
                $('.desktop .category-of-products-step-3 .sub-categories-products li .active').removeClass 'selected'

                TweenMax.to $('.category-of-products .category-of-products-step-2 h4'), 0.25, { css:{opacity: '0'}, delay: 0.15 }
                TweenMax.to $('.category-of-products .category-of-products-step-2 li:nth-child(1)'), 0.25, { css:{opacity: '0'}, delay: 0.4 }
                TweenMax.to $('.category-of-products .category-of-products-step-2 li:nth-child(2)'), 0.25, { css:{opacity: '0'}, delay: 0.55 }
                TweenMax.to $('.category-of-products .category-of-products-step-2 li:nth-child(3)'), 0.25, { css:{opacity: '0'}, delay: 0.7 }

                TweenMax.to $('.category-of-products'), 0.4, { css:{height: '160px'}, onStart: ->
                  $('.menu-products').removeClass 'expand'
                }

                TweenMax.to $('.category-of-products .category-of-products-step-3'), 0.4, { css:{top: '0'} }

                TweenMax.to $('.category-of-products .category-of-products-step-1'), 0.35, { css:{opacity: '0'} }
                TweenMax.to $('.category-of-products .category-of-products-step-1 h3'), 0.35, { css:{opacity: '0'} }
                TweenMax.to $('.category-of-products .category-of-products-step-1 p'), 0.35, { css:{opacity: '0'} }
                TweenMax.to $('.category-of-products .category-of-products-step-1 span'), 0.35, { css:{opacity: '0'} }

                TweenMax.to $('.category-of-products'), 0.5, { css:{width: '470px'}, delay: 0.75, onComplete: ->

                  $('.category-of-products .category-of-products-step-1').css
                    'padding-left': '52px'
                    'padding-right': '52px'

                  $('.category-of-products .category-of-products-step-1 .table').removeClass 'style-animate'

                  $('.category-of-products .category-of-products-step-1 img').css
                    'width': '46px'

                  $('.category-of-products .category-of-products-step-1').css('visibility', 'visible')

                  TweenMax.to $('.category-of-products .category-of-products-step-1'), 0.35, { css:{opacity: '1'} }
                  TweenMax.to $('.category-of-products .category-of-products-step-1 h3'), 0.38, { css:{opacity: '1'} }
                  TweenMax.to $('.category-of-products .category-of-products-step-1 p'), 0.41, { css:{opacity: '1'} }
                  TweenMax.to $('.category-of-products .category-of-products-step-1 span'), 0.43, { css:{opacity: '1'}, onComplete: ->

                    animating = false
                    openedStep3 = false
                    actionFilter = false

                  }

                }

            unless parameters.hasOwnProperty('category_id')
              thoseDays = []
              everyDay = []

              $scope.contentFull = false

              for res in response
                if res.category.slug == 'aqueles-dias' then thoseDays.push( res )
                if res.category.slug == 'todos-os-dias' then everyDay.push( res )

              $scope.categories = [{products: thoseDays}, {products: everyDay}]

            else
              $scope.contentFull = true
              $scope.categories = [{products: response}]

            $('.loader-products').hide()
        , 1000

      else
        query = { category_id: parameters.category_id, sub_category_id: parameters.sub_category_id }

        unless parameters.sub_category_id
          $('.sub-categories-products .selected').removeClass 'selected'
          features = []

        if $(currentTarget).parent().parent().hasClass 'category-of-products-step-2'
          $('.sub-categories-products .selected').removeClass 'selected'
          features = []

        if parameters.feature_id
          quantity = features.length

          features = $.grep features, ( val )->
            return val != parameters.feature_id

          if quantity == features.length
            features.push( parameters.feature_id )

        if features.length > 0
          query.features = "#{features.toString()}"
        else
          delete query['features']

        if btn
          $scope.categories = []
          $('.loader-products').show()

          Products.query(query).$promise.then ( response )->
            $('.loader-products').hide()
            $scope.categories = [{products: response}]
            $scope.contentFull = true

  $scope.getCategories = ->
    Products.query({ action: 'categories' }).$promise.then ( response )->
      $('.loader-menu-products').hide()
      $scope.categoriesaProducts = response
      $scope.$on 'ngRepeatFinished', (ngRepeatFinishedEvent)->
        $scope.addAnimation()

  $scope.getProducts = ->
    if !animating
      Products.query().$promise.then ( response )->
        thoseDays = []
        everyDay = []

        for res in response
          if res.category.slug == 'aqueles-dias' then thoseDays.push( res )
          if res.category.slug == 'todos-os-dias' then everyDay.push( res )

        $('.loader-products').hide()

        $scope.categories = [{products: thoseDays}, {products: everyDay}]

        $scope.$on 'ngRepeatFinished', (ngRepeatFinishedEvent)->
          if $('body').hasClass 'desktop'
            setTimeout ->
              $scope.animateMenu($scope.animateBox)
            , 200

  $scope.addAnimation = ->
    $('.mobile .category-of-products-step-1').off 'click'
    $('.mobile .category-of-products-step-1').on 'click', ->
      $('.category-of-products-step-2.active').removeClass 'active'
      $('.category-of-products-step-3.active').removeClass 'active'
      $(this).parent().find('.category-of-products-step-2').addClass 'active'

    $('.mobile .category-of-products-step-2 li').off 'click'
    $('.mobile .category-of-products-step-2 li').on 'click', ->
      id = $(this).data('id')
      $('.category-of-products-step-3.active').removeClass 'active'
      $(this).parents('.category-of-products').find(".category-of-products-step-3-#{id}").addClass('active')

    $('.mobile .category-of-products-step-3 .sub-categories-products li').off 'click'
    $('.mobile .category-of-products-step-3 .sub-categories-products li').on 'click', ->
      $(this).toggleClass 'selected'

@intimusApp.controller "ProdutosInternaController", ($rootScope, $scope, $routeParams, $sce, $location, Products, WhereToBuy)->
  whereToBuy = false
  $scope.slug = $routeParams.slug
  $scope.url = $location.absUrl()

  $scope.showVideo = ->
    $('.cover, .video-product figcaption i').on 'click', ->
      $('.cover').fadeOut 'fast'

  $scope.getProduct = ->
    Products.get {slug: $routeParams.slug}, (response)->
      $scope.product = response
      string = response.text.replace('**', '<b>')
      string = string.replace('*/*', '</b>')
      console.log string
      $scope.text = $sce.trustAsHtml(string)
      $('.loader-produtos-interna').hide()
      TweenMax.to $('.interna-produtos'), 0.6, { css:{ 'opacity': '1' }, ease: Expo.easeOut }

  $scope.getWhereToBuy = ->
    if !whereToBuy
      WhereToBuy.query().$promise.then ( response )->
        $scope.stores = response

  if $routeParams.buy
    $('.where-to-buy').css 'display', 'block'
    offset = $('.where-to-buy').offset()
    $('body').scrollTop offset.top
    $scope.getWhereToBuy()

  $('.close-shopping-list').on 'click', ->
    $('.where-to-buy').stop().slideUp()

  $('.btn-buy-product').on 'click', ->
    $scope.getWhereToBuy()
    $('.where-to-buy').stop().slideToggle()

@intimusApp.controller "TermosDeUsoController", ($rootScope, $scope)->
@intimusApp.directive 'acordeon', () ->
  link: ->
    $('.open-article').on 'click', ->
      $(@).toggleClass "active"
      $(@).parent().toggleClass "active"
      $(@).parent().next().toggleClass("active").stop().slideToggle()
@intimusApp.directive 'onFinishRender', ($timeout)->
  link: (scope, elements, attrs) ->
    if scope.$last
      $timeout ->
        scope.$emit('ngRepeatFinished')
@intimusApp.directive 'fixedGrid', (FixedGrid) ->
  link: ($scope, element, attrs)->
    $scope.highlights = FixedGrid.query()

    $scope.$on 'ngRepeatFinished', (ngRepeatFinishedEvent)->
      innerHeight = $(element)[0].scrollHeight
      $(element).css "height", "#{innerHeight}px"

@intimusApp.directive 'galleryHighlights', (GalleryHighlights) ->
  link: ($scope, element, attrs)->
    $scope.galleryHighlights = GalleryHighlights.query()

    $scope.$on 'ngRepeatFinished', (ngRepeatFinishedEvent)->
      $('.gallery-highlights').flexslider
        animation: "slide"

      if $('body').hasClass 'desktop'
        TweenMax.to $('.gallery-highlights'), 0.6, { css:{ 'margin-top': '5px', 'opacity': '1' }, delay: 0.7, ease: Expo.easeOut, onComplete: ->
          TweenMax.to $('.woman-things-home'), 0.1, { css:{ 'opacity': '1' } }
          $('.loader-grid-home').hide()
          $('.item-fixed-grid').each (index, item)->
            TweenMax.to $('.item-fixed-grid').eq(index), 0.4, { css:{ opacity: '1' }, ease: Expo.easeOut, delay: index * 0.1 }
        }

@intimusApp.directive 'menu', ($rootScope) ->

  $rootScope.openMenu = ->

    $('.header').addClass "active-menu"

    $('.button-menu').prop "disabled", true

    $(".container-menu").velocity
      opacity: 1

      , {display: "block", duration: 0}


    # ETAPA 1

    # some o botão de menu
    $('.button-menu').velocity
      opacity: [0, 1]
    , {display: "none"}


    # aparece botão de fechar
    $('.close-menu').velocity
      opacity: [1, 0]

    , {display: "block", delay: 1500, complete: ->
      $(this).prop "disabled", false
    }

    # cresce o header até os 100%
    $('.header').velocity
      height: "100%"

    , {duration: 500}

    # ETAPA 2


    # Exibe cada item do menu com fade
    setTimeout ->
      $(".menu-site-link").each (index) ->
        $(this).velocity
          opacity: [1, 0]

        , {delay: index*250}
    , 500

    setTimeout ->
      $('.menu-social-item a').velocity
        opacity: [1, 0]
    , 1600

    return true

  $rootScope.closeMenu = ->

    if $(".header").hasClass("active-menu") and $rootScope.isMobile()

      $('.close-menu').prop "disabled", true

      $('.menu-site-link, .menu-social-item a').velocity
        opacity: 0

      $('.close-menu').velocity
        opacity: 0
      , {delay: 400, duration: 200, display: "none"}

      $('.button-menu').velocity
        opacity: 1
      , {delay: 600, duration: 600, display: "block", complete: ->
        $(this).prop "disabled", false
      }

      $('.header').velocity
        height: if $(window).width() <= 480 then 50 else 100
      , {delay: 600, complete: -> $('.header').removeClass "active-menu"; }

      return true

  link: (scope, controller, element, attrs) ->

    $('.button-menu').on 'click', ->
      $rootScope.openMenu()

    $('.close-menu').on "click", ->
      $rootScope.closeMenu()
@intimusApp.directive 'sliderWomanThingsHome', (WomensThings) ->
  link: ($scope, element, attrs)->

    if $('body').hasClass 'mobile'

      $scope.womanNews = WomensThings.query({ per_page: 4, page: 1 })

      $scope.$on 'ngRepeatFinished', (ngRepeatFinishedEvent)->
        $('.slider-woman-things-content').flexslider
          animation: "slide"

@intimusApp.directive 'suggestedContent', (directive_view_path)->
  scope: {
    slug: '=slug',
    type: '=type'
  }
  templateUrl: "#{directive_view_path}/suggested-content.html"
  replace: true
  controller: ($scope, RelatedContent)->
    console.log $scope.type, $scope.slug
    $scope.relatedContents = RelatedContent.query({ type: $scope.type, slug: $scope.slug })

@intimusApp.directive 'galleryHighlights', (WomanThingsHome) ->
  link: ($scope, element, attrs)->
    WomanThingsHome.query().$promise.then (womanThings)->
      $scope.womanThings1 = womanThings[0]
      $scope.womanThings2 = womanThings[1]
      $scope.womanThings3 = womanThings[2]
      $scope.womanThings4 = womanThings[3]

      $('.woman-things-home-article-1').css('background-color', $scope.womanThings1.background_color)
      $('.woman-things-home-article-2').css('background-color', $scope.womanThings2.background_color)
      $('.woman-things-home-article-3').css('background-color', $scope.womanThings3.background_color)
      $('.woman-things-home-article-4').css
        'background-color': $scope.womanThings4.background_color
        'background-image': "url(#{$scope.womanThings4.image})"

@intimusApp.filter 'toEmbedGrid', ($sce)->
  (embed)->
    inch = 60
    space = 20

    width = (inch * embed.width) + (space * (embed.width - 1))
    height = (inch * embed.height) + (space * (embed.height - 1))

    left = ((embed.column - 1) * inch) + (space * (embed.column - 1))
    top = ((embed.row - 1) * inch) + (space * (embed.row - 1))

    style = "width: #{width}px; height: #{height}px; left: #{left}px; top: #{top}px; position: absolute;"

    if embed.type == 'Imagem'
      $sce.trustAsHtml """ <a href="#{embed.link}" title="#{embed.images.title}" target="#{embed.redirect}"><img class="grid hide-in-mobile" src="#{embed.images.desktop}" style="#{style}" alt="#{embed.images.alt}" > <img class="grid hide-in-desktop" src="#{embed.images.mobile}" alt="#{embed.images.alt}" ></a> """
    else
      $sce.trustAsHtml """
        <iframe class="grid hide-in-mobile" src="#{embed.url}" style="#{style}" frameborder="0"></iframe>
        <iframe class="grid hide-in-desktop" src="#{embed.url}" style="width: 100%; height: #{height}px;" frameborder="0"></iframe> 
      """

window.toYoutubeId = (youtbe_url)->
  if youtbe_url
    videoid = youtbe_url.match(/(?:https?:\/{2})?(?:w{3}\.)?youtu(?:be)?\.(?:com|be)(?:\/watch\?v=|\/)([^\s&]+)/)
    videoid[1] if videoid.length > 0

@intimusApp.filter "toYoutubePlayer", ($sce)->
  (youtube_url)->
    youtube_id = window.toYoutubeId(youtube_url)
    setTimeout ->
      $('#video-container').fitVids()
    , 2000
    $sce.trustAsHtml """
    <iframe src="//www.youtube.com/embed/#{youtube_id}" frameborder="0"></iframe>
    """

@intimusApp.filter "toIframe", ($sce)->
  (url)->
    $sce.trustAsHtml """ <iframe src="#{url}" frameborder="0"></iframe> """

class window.Sequence

  @add = (name, total, format, path='', start=1) ->
    sequence = []
    i = start

    while i <= total
      sequence.push "#{path}#{name}" + i + ".#{format}"
      i++

    sequence

  constructor: (config) ->
    @FPS = config.FPS || 24
    @config = config
    @startPoint = 0
    @i = 0
    @frames = @config.images.length
    @element = @config.target
    @nextFrame()
    @isPlaying = false
    @total = if @config.skip then @config.skip * Math.floor(@frames / @config.skip) else @frames - 1

  setStartPoint: (start) ->
    @startPoint = start

  play: (delay) ->
    unless @isPlaying
      self = @
      @isPlaying = true
      delay = 0  unless delay
      setTimeout (->
        self.currentInterval = setInterval(->
          self.nextFrame()
          return
        , 1000 / self.FPS)
        return
      ), delay * 1000

  nextFrame: ->
    @element.attr "src", @config.path + @config.images[@i]

    if @i is @total
      @complete()
      @i = @startPoint
      clearInterval @currentInterval unless @config.loop

    @i += if @config.skip then @config.skip else 1

  pause: ->
    if @isPlaying
      @isPlaying = false
      clearInterval @currentInterval

  complete: ->
    @config.complete()  if @config.complete

@intimusApp.factory 'Contact', ( $resource )->
  $resource 'api/contact'

@intimusApp.factory 'Error404', ( $resource )->
  $resource "api/error-tags"

@intimusApp.factory "FixedGrid", ($resource)->
  $resource "api/home/grid"

@intimusApp.factory "GalleryHighlights", ($resource)->
  $resource "api/home/highlights"

@intimusApp.factory 'Products', ( $resource )->
  $resource 'api/products/:action/:slug', { slug: '@slug' }

@intimusApp.factory 'RelatedContent', ( $resource )->
  $resource 'api/:type/related/:slug', { type: '@type', slug: '@slug' }

@intimusApp.factory 'WhereToBuy', ( $resource )->
  $resource 'tmp/where-to-buy.json'

@intimusApp.factory "WomanThingsHome", ($resource)->
  $resource "api/home/womens-things/"

@intimusApp.factory "WomensThings", ($resource)->
  $resource "api/womens-things/:action/:slug", { action: '@action', slug: '@slug' },
    {
      search: {
        method: 'GET',
        params: { action: 'search' },
        isArray: true
      }
    }

@intimusApp.factory 'httpInterceptor', ( $q, $location )->
  response: ( response )->
    response || $q.when( response )

  responseError: ( response )->
    if response.status == 404
      $location.path('/404')

@intimusApp.constant "view_path", "public/views"
@intimusApp.constant "directive_view_path", "public/views/directives"

@intimusApp.run ($rootScope, $route)->

  # $rootScope.animateLoader = ->
  #   TweenMax.to $('.loader-fake-header'), 1.5, {css:{ 'width': '100%' }, ease: Expo.easeOut, onComplete: ->
  #     TweenMax.to $('.header'), 0.7, {css:{ 'margin-top': '0px', 'opacity': '1' }, ease: Expo.easeOut }
  #     TweenMax.to $('.gallery-highlights'), 0.6, { css:{ 'margin-top': '6px', 'opacity': '1' }, delay: 0.7, ease: Expo.easeOut }
  #   }
  #
  #   return false

  $rootScope.hexToRgb = (hex) ->

    shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i
    hex = hex.replace(shorthandRegex, (m, r, g, b) ->
      r + r + g + g + b + b
    )
    result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
    if result
      r: parseInt(result[1], 16)
      g: parseInt(result[2], 16)
      b: parseInt(result[3], 16)
    else
      null

  $rootScope.isMobile = ->
    $("body").hasClass "mobile"

  $rootScope.isDesktop = ->
    $("body").hasClass "desktop"

  $rootScope.resetMenu = ->
    $('.header, .header *').attr "style", ""

    $('.button-menu').prop "disabled", false
    $('.close-menu').prop "disabled", true

    $('.header').removeClass "active-menu"

  width = $(window).width()

  if width >= 681
    reload = true
    $('body').addClass('desktop')
  else
    $('body').addClass('mobile')
    reload = false

  $(window).resize ->
    width = $(window).width()

    if width >= 681 and !reload
      reload = true
      $('body').removeClass('mobile').addClass('desktop')
      $route.reload()

    else if width <= 680 and reload
      reload = false
      $('body').removeClass('desktop').addClass('mobile')
      $route.reload()

    if $rootScope.isDesktop()
      $rootScope.resetMenu()

    $rootScope.resetMenu() if !$(".header").hasClass "active-menu"
    $(".mobile .container-menu").css
      height: $(window).height() - 100

  $rootScope.$on "$routeChangeStart", (event, currRoute, prevRoute)->
    # TweenMax.to $('.loader-page'), 0.5, { css:{ 'height': '100%', 'opacity': '0.6' }, ease: Expo.easeOut, onComplete: ->
    #   TweenMax.to $('.loader-page'), 0.5, { css:{ 'height': '5px', 'opacity': '1' }, ease: Expo.easeOut }
    # }
    $(window).trigger "resize"
    $rootScope.title = currRoute.title
    $('body, html').scrollTop(0)

@intimusApp.config ($httpProvider, $routeProvider, $locationProvider, view_path)->

  $locationProvider.html5Mode(true).hashPrefix('!')

  $httpProvider.interceptors.push('httpInterceptor')

  $routeProvider
    .when "/",
      templateUrl: "#{view_path}/home/index.html",
      controller: "HomeController",
      title: "Intimus"

    .when "/produtos",
      templateUrl: "#{view_path}/produtos/index.html",
      controller: "ProdutosController",
      title: "Produtos"

    .when "/produtos/:slug",
      templateUrl: "#{view_path}/produtos/show.html",
      controller: "ProdutosInternaController",
      title: "Produtos - Interna"

    .when "/produtos/:slug/:buy",
      templateUrl: "#{view_path}/produtos/show.html",
      controller: "ProdutosInternaController",
      title: "Produtos - Interna"
      
    .when "/coisas-de-mulher",
      templateUrl: "#{view_path}/coisas-de-mulher/index.html",
      controller: "CoisasDeMulherController",
      title: "Coisas de Mulher"

    .when "/coisas-de-mulher/:slug",
      templateUrl: "#{view_path}/coisas-de-mulher/show.html",
      controller: "CoisasDeMulherInternaController",
      title: "Coisas de Mulher - Interna"

    .when "/contato",
      templateUrl: "#{view_path}/contato/index.html",
      controller: "ContatoController",
      title: "Contato"

    .when "/termos-de-uso",
      templateUrl: "#{view_path}/termos/termos-de-uso.html",
      title: "Termos de Uso"

    .when "/politica-de-privacidade",
      templateUrl: "#{view_path}/termos/politica-de-privacidade.html",
      title: "Política de Privacidade"

    .when "/404",
      templateUrl: "#{view_path}/errors/404.html",
      controller: "Error404Controller",
      title: "404"

    .when "/calendario-menstrual",
      templateUrl: "#{view_path}/calendario-menstrual/master.html",
      controller: "CalendarioMenstrualMainController",
      title: "Calendario Mestrual"
      
    .when "/calendario-menstrual/:page",
      templateUrl: "#{view_path}/calendario-menstrual/master.html",
      controller: "CalendarioMenstrualMainController",
      title: "Calendario Mestrual"
      
    .otherwise
      redirectTo: "/404"
