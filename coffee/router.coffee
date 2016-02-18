###*
 * Router module
 * @author AlexSuslov<suslov@me.com>
 * @created 2016-02-18
###

App.Router = Backbone.Router.extend
  routes:
    help          : 'help'
    config        : 'config'
    hardware      : 'hardware'
    devices       : 'devices'
    tools         : 'tools'
    'devices/:id' : 'device'
    ''            : 'summary'

  summary:->
    new App.Views.Main(el:'.container')
    @

  help:->
    console.log 'help'

  config:->
    new App.Views.Config(el:'.container')
    @

  hardware:->
    new App.Views.Hardware(el:'.container')
    @

  devices:->
    new App.Views.Devices(el:'.container')
    console.log 'devices'

  device:(id)->
    new App.Views.Device(el:'.container')
    console.log 'device'

  tools:(id)->
    new App.Views.Tools(el:'.container')
    console.log 'tools'


App.router = new App.Router()

Backbone.history.start();
