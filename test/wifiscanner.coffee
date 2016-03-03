config = require '../config'
request = require 'request'

url = config.apiPrefix + "/api?q=7"

describe 'WIFI SCANNER', ->
  @timeout(5000);
  it "[get]#{url}", (done)->

    request url, (err, response, body)->
      if (!err and response.statusCode is 200)
        json = JSON.parse( body )
        throw "scanner list not array" unless Array.isArray( json)
        done()
      else
        throw err

