helpers = require './helpers'
util = require 'util'
should = require 'should'
async = require 'async'
_ = require 'underscore'
CacheManager = require('../').CacheManager

describe 'zzcache:', ->

    # prepare
    before (done) -> helpers.before(done)
    after (done) -> helpers.after(done)

    # test each provider in loop
    _.each helpers.providers(),
    (provider, cb) -> describe provider.name, ->

        #
        cache = null
        key = helpers.randomString 10
        value = helpers.randomString 200

        #
        it 'Should be able to connect', (done) ->
            cache = new CacheManager provider.name, provider.options, null, (error) ->
                should.not.exist error
                should.exist cache.provider
                if provider.name == 'redis'
                    should.exist cache.provider.redis_connection
                    cache.provider.redis_connection.connected.should.be.equal true
                done()

        #
        it 'Should be able to set', (done) ->
            cache.set key, value, (error) ->
                should.not.exist error
                done()

        #
        it 'Should be able to get', (done) ->
            cache.get key, (error, data) ->
                should.not.exist error
                should.exist data
                data.should.be.equal value
                done()

        #
        it 'Should be able to del', (done) ->
            cache.del key, (error) ->
                should.not.exist error
                cache.get key, (error, data) ->
                    should.not.exist data
                    done()

        #
        it 'Should be able to expire', (done) ->
            cache = new CacheManager provider.name, provider.options, 1, (error) ->
                should.not.exist error
                cache.set key, value, (error) ->
                    should.not.exist error
                    setTimeout (->
                        cache.get key, (error, data) ->
                            should.exist error
                            should.not.exist data
                            done()
                    ), 1000

        #
        it 'Should be able to del_pattern', (done) ->
            prefix = 'del_pattern:'

            async.waterfall [

                (cb) ->
                    data = []
                    for i in [1..10]
                        key = helpers.randomString 10
                        value = helpers.randomString 200
                        data.push key: prefix + key, value: value
                    cb null, data

                (data, cb) ->
                    for i in [1..10]
                        key = helpers.randomString 10
                        value = helpers.randomString 200
                        data.push key: key, value: value
                    cb null, data

                (data, cb) ->
                    async.each data, ((d, cb_) -> cache.set d.key, d.value, cb_ null), -> cb null, data

                (data, cb) ->
                    async.each data, ((d, cb_) ->
                        if d.key.indexOf prefix == 0
                            cache.del_pattern prefix, (error) ->
                                should.not.exist error
                                cb_ null
                        else cb_ null
                    ), -> cb null, data

                (data, cb) ->
                    async.each data, ((d, cb_) ->
                        if d.key.indexOf prefix == 0
                            cache.get prefix, (error, dd) ->
                                should.exist error
                                should.not.exist dd
                                cb_ null
                        else
                            cache.get prefix, (error, dd) ->
                                should.not.exist error
                                should.exist dd
                                cb_ null
                    ), -> cb null, data

                (data, cb) ->
                    async.each data, ((d, cb_) ->
                        cache.del d.key, -> cb_ null
                    ), -> cb null

            ], (error) ->
                should.not.exist error
                done()

