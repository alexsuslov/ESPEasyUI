config = require '../config'
request = require 'request'


# { name: 'newdevice',
#   usedns: '0',
#   unit: '0',
#   protocol: '1',
#   controllerip: [ 192, 168, 0, 8 ],
#   espip: [ 0, 0, 0, 0 ],
#   espsubnet: [ 0, 0, 0, 0 ],
#   espdns: [ 0, 0, 0, 0 ],
#   espgateway: [ 0, 0, 0, 0 ],
#   controllerhostname: '',
#   delay: '60',
#   deepsleep: '0',
#   controllerport: '8080',
#   ssid: 'Rebma',
#   key: 'tab-id-woF',
#   apkey: 'configesp',
#   controllerpassword: '',
#   controlleruser: '' }

objParam = (data)->
  Object.keys(data).map( (k)->
    encodeURIComponent(k) + '=' + encodeURIComponent(data[k])
  ).join('&')

url = config.apiPrefix + "config"

describe 'config api test', ->
#   @timeout(5000);
  it '[get]/[post]', (done)->
    get = (url, fn)->
      request.get url, (err, response, body)->
        throw err if (err and !response.statusCode is 200)
        fn JSON.parse(body)

    get url, (data)->
      data.name = 'NewDevice'
      opt =
        url : url
        body : objParam data
      request.post opt, (err, response, body)->
        throw err if (err and !response.statusCode is 200)
        json = JSON.parse(body)
        throw new Error 'config update error' if json.name isnt 'NewDevice'
        done()


