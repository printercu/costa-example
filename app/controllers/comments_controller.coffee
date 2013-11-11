Comment = require '../models/comment'

module.exports =
class CommentsController extends require './application_controller'
  @extendsWithProto()

  @beforeFilter 'findItem', only: ['show', 'edit', 'update', 'delete']

  indexAction: ->
    @render {}

  newAction: ->
    @render new Comment

  createAction: ->
    item = new Comment @itemParams
    item.account_id = @req.account.id
    item.save (err) =>
      # console.log item
      if err
        if item.errors.hasAny
          @res.format
            json: -> @status(422).jsonp item.exportFor 'api' # unprocessable_entity
            html: ->
              @flash 'error', item.errors.first()
              @redirect '/events/new'
        else
          @next(err)
      else
        url = "/events/#{item.id}"
        @res.format
          json: -> @status(201).set('Location', url).jsonp item.exportFor 'api' # created
          html: ->
            @flash 'Event created'
            @redirect url

  showAction: ->
    @res.json @item

  findItem: (callback) ->
    Comment.find @req.param('id'), @handleErrors (err, item) =>
      @item = item
      callback()

  allowed_params = [
    'name'
    'description'
    'place'
    'address'
    'location'
    'starts_at'
    'ends_at'
  ]

  Object.defineProperty @::, 'itemParams', get: ->
    result = @params allowed_params...
    result.avatar = avatar if avatar = @fileParam 'avatar'
    parse_params.parseDates result, @req.session.tz_offset,
      'starts_at'
      'ends_at'
    # console.log result
    result
