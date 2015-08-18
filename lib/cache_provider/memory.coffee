_ = require 'underscore'
CacheProvider = require './cache_provider'

class MemoryCacheProvider extends CacheProvider

    data: {}

    get: (key, cb) =>
        if key of @data then if _.isFunction cb then cb null, @data[key]
        else if _.isFunction cb then cb 'no key', null

    set: (key, value, cb) =>
        @data[key] = value
        if @options.cache_expire_time
            setTimeout (-> delete @data[key]), @options.cache_expire_time * 1000
        if _.isFunction cb then cb null

    del: (key, cb) =>
        delete @data[key]
        if _.isFunction cb then cb null

    del_pattern: (pattern, cb) =>
        _.each @data, (item, key) =>
            if key.indexOf(pattern) == 0
                if key of @data then delete @data[key]
        if _.isFunction cb then cb null

module.exports = MemoryCacheProvider