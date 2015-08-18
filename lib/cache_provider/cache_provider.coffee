_ = require 'underscore'

class CacheProvider

    constructor: (options, cb) ->
        @redis_connection = null
        @setup_options options
        @prepare (error) ->
            if error then console.log 'cache provider connection error'
            if _.isFunction cb then process.nextTick -> cb error
        @

    setup_options: (options) ->
        @options = options

    prepare: (cb) ->
        cb null
        @

    get: (key, cb) ->
        cb null
        @

    set: (key, value, cb) ->
        cb null
        @

    del: (key, cb) ->
        cb null
        @

    del_pattern: (pattern, cb) ->
        cb null
        @

module.exports = CacheProvider
