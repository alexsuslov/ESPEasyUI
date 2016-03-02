config = require '../config'
request = require 'request'

url = config.apiPrefix + "/api?q=5"

objParam = (data)->
  Object.keys(data).map( (k)->
    encodeURIComponent(k) + '=' + encodeURIComponent(data[k])
  ).join('&')


describe 'advanced api test', ->
  it '[get]/[post]', (done)->
    get = (url, fn)->
      request.get url, (err, response, body)->
        throw err if (err and !response.statusCode is 200)
        fn JSON.parse(body)

    get url, (data)->
      tmp = "" + data.MQTTsubscribe

      data.MQTTsubscribe = '/home/#'
      opt =
        url : url
        body : objParam data

      request.post opt, (err, response, body)->
        throw err if (err and !response.statusCode is 200)
        json = JSON.parse(body)
        throw new Error 'Advanced update MQTTsubscribe error' if json.MQTTsubscribe isnt '/home/#'

        # restore data
        data.MQTTsubscribe = tmp
        opt.body = objParam data
        request.post opt, (err, response, body)->
          done()


