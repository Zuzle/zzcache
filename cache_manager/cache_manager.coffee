_ = require 'underscore'
CachableClass = require '../cachable_class/cachable_class'

class CacheManager

    constructor: (@provider_name, @provider_options, @cache_expire_time) ->
        if not @provider_options then @provider_options = {}
        if not @provider_name then throw Error 'invialid arguments'
        @init_provider()
        @

    init_provider: ->
        @Provider = require '../cache_provider/' + @provider_name
        @provider = new @Provider _.extend _.clone(@provider_options), cache_expire_time: @cache_expire_time

    # helpers

    make_cachable: (object) ->
        object = _.extend object, CachableClass.prototype
        object.cache_provider = @provider
        @

    # shortcuts

    get: (args...) -> @provider.get args

    set: (args...) -> @provider.set args

    del: (args...) -> @provider.del args

    del_pattern: (args...) -> @provider.del_pattern args

module.exports = CacheManager
