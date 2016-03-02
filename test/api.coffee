config = require '../config'
request = require 'request'

url = config.apiPrefix + '/api?q=0'

describe 'Api', ->
  it '[get]', (done)->

    request url, (err, response, body)->
      if (!err and response.statusCode is 200)
        json = JSON.parse( body )
        # throw "devices not array" unless Array.isArray( json)
        done()
      else
        throw err

