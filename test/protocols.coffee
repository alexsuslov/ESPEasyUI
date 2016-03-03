config = require '../config'
request = require 'request'

url = config.apiPrefix + "/api?q=10"

describe 'PROTOCOLS', ->
  @timeout config.timeout
  it "[get]#{url} list protocols", (done)->

    request url, (err, response, body)->
      if (!err and response.statusCode is 200)
        json = JSON.parse( body )
        throw "Protocols is not array" unless Array.isArray(json)
        done()
      else
        throw err || response.statusCode

