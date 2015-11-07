_ = require 'underscore'
CacheProvider = require './cache_provider'

class MemoryCacheProvider extends CacheProvider

    data: {}

    get: (key, cb) =>
        @check_data_exists()
        if key of @data then if _.isFunction cb then cb null, @data[key]
        else if _.isFunction cb then cb 'no key', null

    set: (key, value, cb) =>
        @check_data_exists()
        @data[key] = value
        if @options.cache_expire_time
            setTimeout (=> @do_del key), @options.cache_expire_time * 1000
        if _.isFunction cb then cb null

    del: (key, cb) =>
        @do_del key
        if _.isFunction cb then cb null

    del_pattern: (pattern, cb) =>
        _.each @data, (item, key) =>
            if key.indexOf(pattern) == 0
                if key of @data then @do_del key
        if _.isFunction cb then cb null

    do_del: (key) =>
        @check_data_exists()
        delete @data[key]

    check_data_exists: =>
        if not @data then @data = {}

module.exports = MemoryCacheProvider