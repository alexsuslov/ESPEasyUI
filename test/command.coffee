config = require '../config'
request = require 'request'


objParam = (data)->
  Object.keys(data).map( (k)->
    encodeURIComponent(k) + '=' + encodeURIComponent(data[k])
  ).join('&')

url = config.apiPrefix + "/api/command"

describe 'command api test', ->
  it '[post]', (done)->
    get url, (data)->
      data.p0 = 'cmd'
      opt =
        url : url
        body : objParam data
      request.post opt, (err, response, body)->
        throw err if (err and !response.statusCode is 200)
        json = JSON.parse(body)
        throw new Error 'config update error' if json.p0 isnt '1'
        done()


