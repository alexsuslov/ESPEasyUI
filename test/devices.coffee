# config = require '../config'
# request = require 'request'

# url = config.apiPrefix + "/api?q=11"

# describe 'DEVICES', ->
#   @timeout config.timeout
#   it "[get]#{url}", (done)->

#     request url, (err, response, body)->
#       if (!err and response.statusCode is 200)
#         json = JSON.parse( body )
#         throw "devices not array" unless Array.isArray( json)
#         done()
#       else
#         throw err

