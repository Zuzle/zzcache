_ = require 'underscore'

# This class is only for extending another classes

class CachableClass

    cachable_action_key: (args) ->
        _.filter(args, (a) ->
            if _.isArray(a) then a = a.join '-'
            return _.isString(a) or _.isNumber(a)).join(':')

    cachable_action: (args...) ->

        key = @cachable_action_key args

        @cache_provider.get key, (error, data) =>
            cb = args[args.length-1]

            if not error and data then cb error, data

            else
                console.log 1
                action = args[0]
                args = args.slice 1, args.length
                args.pop()
                args.push (error, data) =>
                    @cache_provider.set key, data, -> cb error, data
                @[action].apply @, args

module.exports = CachableClass
