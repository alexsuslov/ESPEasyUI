config = require '../config'
request = require 'request'


objParam = (data)->
  Object.keys(data).map( (k)->
    encodeURIComponent(k) + '=' + encodeURIComponent(data[k])
  ).join('&')

url = config.apiPrefix + "/api/cmd"

describe 'command api test', ->
  it '[post]', (done)->

   data=
    c: 'Settings'
   opt =
     url : url
     body : objParam data
   request.post opt, (err, response, body)->
     throw err if (err and !response.statusCode is 200)
     json = JSON.parse(body)
     done()


