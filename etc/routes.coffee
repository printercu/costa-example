ACTIONS_ON_COLLECTION =
  GET:    'index'
  POST:   'create'
  PUT:    'create'
  DELETE: 'deleteAll'

ACTIONS_ON_ITEM =
  GET:    'show'
  POST:   'update'
  PUT:    'update'
  DELETE: 'delete'

actions_get_allowed = ['new', 'edit']

controllers = {}

dispatch = (req, res, next) ->
  c_class = controllers[req.params.controller]
  return next 404 unless c_class #not_found
  action = req.params.action ||
    (req.params.id && ACTIONS_ON_ITEM[req.method]) ||
    ACTIONS_ON_COLLECTION[req.method] ||
    'index'
  c_class.dispatch action, req, res, next

lingo = require 'lingo'
module.exports = ->
  for name, obj of @controllers
    controllers[lingo.underscore(name).replace /_controller$/, ''] = obj

  @get '/:controller(posts)/new', (req) ->
    req.params.action = 'new'
    dispatch arguments...
  @all '/:controller(posts|comments)/:id?/:action?.:format?', dispatch
  @get '/:action?.:format?', (req) ->
    req.params.controller = 'posts'
    dispatch arguments...
