module.exports = (callback) ->
  @set 'views', "#{@root}/app/views"

  @set 'view engine', 'jade'

  callback()
