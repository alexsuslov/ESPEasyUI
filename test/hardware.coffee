config = require '../config'
request = require 'request'


objParam = (data)->
  Object.keys(data).map( (k)->
    encodeURIComponent(k) + '=' + encodeURIComponent(data[k])
  ).join('&')

url = config.apiPrefix + "/api?q=2"

describe 'HARDWARE', ->
  @timeout config.timeout
  it "[get]/[post]#{url}", (done)->
    get = (url, fn)->
      request.get url, (err, response, body)->
        throw err if (err and !response.statusCode is 200)
        fn JSON.parse(body)

    get url, (data)->
      # create tmp env
      tmp = '' + data.p0
      # set test "1"
      data.p0 = '1'
      # options 4 request
      opt =
        url : url
        body : objParam data
      # send post request
      request.post opt, (err, response, body)->
        # throw err if status not 200
        throw err if (err and !response.statusCode is 200)
        # parse json
        json = JSON.parse(body)
        # throw err if response p0 not "1"
        throw new Error 'Hardware config update error' if json.p0 isnt '1'
        # restore data
        data.p0 = tmp
        # create param body
        opt.body = objParam data
        request.post opt, (err, response, body)->
          done()


