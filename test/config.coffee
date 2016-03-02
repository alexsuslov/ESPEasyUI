config = require '../config'
request = require 'request'

objParam = (data)->
  Object.keys(data).map( (k)->
    encodeURIComponent(k) + '=' + encodeURIComponent(data[k])
  ).join('&')

url = config.apiPrefix + "/api?q=1"

describe 'config api test', ->
  it '[get]/[post]', (done)->
    get = (url, fn)->
      request.get url, (err, response, body)->
        throw err if (err and !response.statusCode is 200)
        fn JSON.parse(body)

    get url, (data)->
      tmpName = "" + data.name
      tmpDelay = "" + data.delay
      data.name = 'testName'
      data.delay = '100'
      opt =
        url : url
        body : objParam data
      request.post opt, (err, response, body)->
        throw err if (err and !response.statusCode is 200)
        json = JSON.parse(body)
        throw new Error 'config update name error' if json.name isnt 'testName'
        throw new Error 'config update delay error' if json.delay isnt '100'
        # restore data
        data.name = tmpName
        data.delay = tmpDelay
        opt.body = objParam data
        request.post opt, (err, response, body)->
          done()


