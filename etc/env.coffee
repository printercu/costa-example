module.exports = ->
  process.env.TZ = 'UTC'

  @set 'port', process.env.PORT || 3000

  @set 'trust proxy', true

  VALID_ENVS  = ['development', 'production', 'test']
  DEFAULT_ENV = 'development'

  @set 'env', DEFAULT_ENV unless @set('env') in VALID_ENVS

  try env = require("./env/#{@set 'env'}")
  env?.call @
