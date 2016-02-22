request = require 'request'
url = "http://10.0.1.32/api/wifiscanner"

describe 'wifi scanner api', ->
  this.timeout(5000);
  it '[get]', (done)->

    request url, (err, response, body)->
      if (!err and response.statusCode is 200)
        json = JSON.parse( body )
        throw "scanner list not array" unless Array.isArray( json)
        done()
      else
        throw err

