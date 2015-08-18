_ = require 'underscore'
async = require 'async'
CacheProvider = require './cache_provider'

class RedisCacheProvider extends CacheProvider

    setup_options: (options) ->
        if not options then options = {}
        if not options.port then options.port = 6379
        if not options.host then options.host = '127.0.0.1'
        super options

    prepare: (cb) ->
        redis = require('redis').createClient
        @redis_connection = redis @options.port, @options.host, auth_pass: @options.auth_pass
        @redis_connection.on 'connect', -> cb null
        @

    get: (key, cb) =>
        @redis_connection.get key, (error, data) =>
            try
                data = JSON.parse data
                cb error, data
            catch error
                cb error

    set: (key, value, cb) =>
        @redis_connection.set key, JSON.stringify(value), (error) -> cb error
        if @options.cache_expire_time
            @redis_connection.expire key, @options.cache_expire_time

    del: (key, cb) =>
        @redis_connection.del key, (error) -> cb error

    del_pattern: (pattern, cb) =>
        @redis_connection.keys pattern, (error, rows) =>
            async.each rows, @del, cb

module.exports = RedisCacheProvider