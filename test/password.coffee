# config = require '../config'
# request = require 'request'



# url = config.apiPrefix + "wifiscanner"

# describe 'wifi scanner api', ->
#   @timeout(5000);
#   it '[get]', (done)->

#     request url, (err, response, body)->
#       if (!err and response.statusCode is 200)
#         json = JSON.parse( body )
#         throw "scanner list not array" unless Array.isArray( json)
#         done()
#       else
#         throw err

