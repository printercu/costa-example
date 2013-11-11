module.exports =
class Comment extends require './base_record'
  @extendsWithProto()

  @exportAttrs 'body'

  @validatesPresenceOf 'body'
