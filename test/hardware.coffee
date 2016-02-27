config = require '../config'
request = require 'request'


objParam = (data)->
  Object.keys(data).map( (k)->
    encodeURIComponent(k) + '=' + encodeURIComponent(data[k])
  ).join('&')

url = config.apiPrefix + "/api/hardware"

describe 'hardware api test', ->
  it '[get]/[post]', (done)->
    get = (url, fn)->
      request.get url, (err, response, body)->
        throw err if (err and !response.statusCode is 200)
        fn JSON.parse(body)

    get url, (data)->
      data.p0 = 1
      opt =
        url : url
        body : objParam data
      request.post opt, (err, response, body)->
        throw err if (err and !response.statusCode is 200)
        json = JSON.parse(body)
        # console.log json
        throw new Error 'Hardware config update error' if json.p0 isnt 1
        done()


