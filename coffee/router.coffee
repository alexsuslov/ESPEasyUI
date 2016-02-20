###*
 * Router module
 * @author AlexSuslov<suslov@me.com>
 * @created 2016-02-18
###

App.Router = Backbone.Router.extend
  routes:
    config        : 'config'
    hardware      : 'hardware'
    devices       : 'devices'
    tools         : 'tools'
    'devices/:id' : 'device'
    ''            : 'summary'
  Forms:
    auth     : new App.Views.Auth( el:'.login')
    main     : new App.Views.Main( el:'.main')
    config   : new App.Views.Config(el:'.config')
    hardware : new App.Views.Hardware(el:'.hardware')
    devices  : new App.Views.Devices(el:'.devices')
  initialize:->
    @

  summary:->
    $('.block').hide()
    $('.login').show()
    # @Forms.main.render()
    $('.main').show()
    @

  help:->
    console.log 'help'

  config:->
    $('.block').hide()
    @Forms.config.model.fetch()
    $('.config').show()
    @

  hardware:->
    $('.block').hide()
    @Forms.hardware.model.fetch()
    $('.hardware').show()
    @

  devices:->
    $('.block').hide()
    @Forms.devices.collection.fetch()
    $('.devices').show()
    @

  device:(id)->
    console.log 'device', id
    device = new Models.Device(id:id)
    device.fetch()

  tools:(id)->
    new App.Views.Tools(el:'.container')
    console.log 'tools'


App.router = new App.Router()

Backbone.history.start();
