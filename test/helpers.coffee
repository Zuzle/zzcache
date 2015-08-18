async = require 'async'
_ = require 'underscore'

helpers =

    config:
        providers:
            memory: {}
            redis:
                port: 6379
                host: '127.0.0.1'

    providers: ->
        r = []
        _.each helpers.config.providers, (options, name) -> r.push options: options, name: name
        r

    chars: '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

    randomString: (length) ->
        result = ''
        i = length
        while i > 0
            result += helpers.chars[Math.round(Math.random() * (helpers.chars.length - 1))]
            --i
        result

    before: (done) -> done()

    after: (done) -> done()

    eachProvider: (cb, done) ->
        async.each helpers.config.providers, cb, done

module.exports = helpers
