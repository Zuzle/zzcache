# zzcache
JS library to handle set/get/del/del_pattern operations for cache

## install

    npm i zzcache --save

##  tests

    npm test

## usage

### coffesscript

    provider_name = 'redis'
    provider_options =
        port: 6379
        host: '127.0.0.1'
    expire_time = 3600 # expire time in seconds
    key = 'vbnmum09n87b6v'
    value = '7b8n9m0nb87v5667b'


    CacheManager = require('../').CacheManager
    cache = new CacheManager provider_name, provider_options, expire_time, (error) ->

    cache.set key, value, (error) ->

    cache.get key, (error, value) ->

    cache.del key, (error) ->

    cache.del_pattern pattern, (error) ->
