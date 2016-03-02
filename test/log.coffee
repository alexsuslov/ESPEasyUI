config = require '../config'
request = require 'request'

url = config.apiPrefix + "/api?q=6"

describe 'Log api', ->
  it '[get]', (done)->

    request url, (err, response, body)->
      if (!err and response.statusCode is 200)
        json = JSON.parse( body )
        throw "devices not array" unless Array.isArray( json)
        done()
      else
        throw err

