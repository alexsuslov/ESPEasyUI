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
  Forms:{}
  initialize:->
    @

  summary:->
    @Forms.main = new App.Views.Main( el:'.main') unless @Forms.main
    $('.block').hide()
    # @Forms.main.render()
    $('.main').show()
    @

  help:->
    console.log 'help'

  config:->
    @Forms.config = new App.Views.Config(el:'.config') unless @Forms.config
    $('.block').hide()
    @Forms.config.model.fetch()
    $('.config').show()
    @

  hardware:->
    @Forms.hardware = new App.Views.Hardware(el:'.hardware') unless @Forms.hardware
    $('.block').hide()
    @Forms.hardware.model.fetch()
    $('.hardware').show()
    @

  devices:->
    @Forms.devices = new App.Views.Devices(el:'.devices') unless @Forms.devices
    $('.block').hide()
    @Forms.devices.collection.fetch()
    $('.devices').show()
    @

  device:(id)->
    new App.Views.Device(el:'.container')
    console.log 'device'

  tools:(id)->
    new App.Views.Tools(el:'.container')
    console.log 'tools'


App.router = new App.Router()

Backbone.history.start();
