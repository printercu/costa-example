Post = require '../models/post'
resource_class = Post

module.exports =
class PostsController extends require './application_controller'
  @extendsWithProto()

  @beforeFilter 'authenticate', only: ['create', 'update']
  @beforeFilter 'buildResource', only: ['new', 'create']
  @beforeFilter 'findResource', only: ['show', 'edit', 'update', 'delete']

  indexAction: ->
    resource_class.all @handleErrors (err, @collection) =>
      @render {@collection}

  newAction: ->
    @render {@resource}

  createAction: ->
    @resource.save (err) =>
      if err
        if @resource.errors.hasAny
          @res.format
            json: => @res.status(422).jsonp @resource.exportFor 'api' # unprocessable_entity
            html: =>
              @res.flash 'error', @resource.errors.first()
              @res.redirect "/posts/new"
        else
          @next(err)
      else
        url = "/posts/#{@resource.id}"
        @res.format
          json: => @res.status(201).set('Location', url).jsonp @resource.exportFor 'api' # created
          html: =>
            @res.flash 'Item created'
            @res.redirect url

  showAction: ->
    @render {@resource}

  editAction: ->
    @render {@resource}

  updateAction: ->
    @resource.update @itemParams, (err) =>
      if err
        if @resource.errors.hasAny
          @res.format
            json: => @res.status(422).jsonp @resource.exportFor 'api' # unprocessable_entity
            html: =>
              @res.flash 'error', @resource.errors.first()
              @res.redirect "/posts/#{@resource.id}/edit"
        else
          @next(err)
      else
        url = "/posts/#{@resource.id}"
        @res.format
          json: => @res.jsonp @resource.exportFor 'api'
          html: =>
            @res.flash 'Item updated'
            @res.redirect url

  authenticate: (callback) ->
    @res.flash 'error', 'Not allowed'
    @res.redirect "/posts"

  buildResource: (callback) ->
    @resource = resource_class.create @itemParams
    callback()

  findResource: (callback) ->
    resource_class.find @req.param('id'), @handleErrors (err, @resource) =>
      callback()

  allowed_params = [
    'title'
    'body_md'
  ]

  Object.defineProperty @::, 'itemParams', get: ->
    @params allowed_params...
