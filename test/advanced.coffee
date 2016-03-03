config = require '../config'
request = require 'request'

url = config.apiPrefix + "/api?q=5"

objParam = (data)->
  Object.keys(data).map( (k)->
    encodeURIComponent(k) + '=' + encodeURIComponent(data[k])
  ).join('&')


describe 'ADVANCED', ->
  @timeout config.timeout
  it "[get]/[post]#{url}", (done)->
    get = (url, fn)->
      request.get url, (err, response, body)->
        throw err if (err and !response.statusCode is 200)
        fn JSON.parse(body)

    get url, (data)->
      tmp = "" + data.mqttsubscribe

      data.mqttsubscribe = '/home/#'
      data.edit = '1'
      opt =
        url : url
        body : objParam data

      request.post opt, (err, response, body)->
        throw err if (err and !response.statusCode is 200)
        json = JSON.parse(body)
        throw new Error 'Advanced update MQTTsubscribe error' if json.mqttsubscribe isnt '/home/#'

        # restore data
        data.mqttsubscribe = tmp
        opt.body = objParam data
        request.post opt, (err, response, body)->
          done()


