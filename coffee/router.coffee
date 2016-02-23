###*
 * Router module
 * @author AlexSuslov<suslov@me.com>
 * @created 2016-02-18
###
if window.data
  App.model = new Models.Main(window.data)
else
  App.model = new Models.Main()


App.Router = Backbone.Router.extend
  login:false
  routes:
    logout        : 'logout'
    config        : 'config'
    hardware      : 'hardware'
    devices       : 'devices'
    tools         : 'tools'
    log           : 'log'
    wifi          : 'wifi'
    'devices/:id' : 'device'
    ''            : 'summary'

  Forms:
    tools    : new App.Views.Tools( el:'.tools').render()
    log      : new App.Views.Log( el:'.log')
    login    : new App.Views.Auth( model:App.model, el:'.login').render()
    main     : new App.Views.Main( model:App.model, el:'.main')
    config   : new App.Views.Config(el:'.config')
    hardware : new App.Views.Hardware(el:'.hardware')
    devices  : new App.Views.Devices(el:'.devices')
    wifi     : new App.Views.Wifi(el:'.wifi')

  initialize:->
    # logout
    Backbone.on 'onLogin', =>
      @summary()
    Backbone.on 'onLogout', =>
      App.model.clear()
      @summary()
    @

  wifi:->
    col = @Forms.wifi.collection
    @showPage 'wifi' , (fn)=>
      col.on 'sync', ->fn()
      col.fetch()
    @


  log:->
    col = @Forms.log.collection
    @showPage 'log' , (fn)=>
      col.on 'sync', ->fn()
      col.fetch()
    @

  logout:->
    Backbone.trigger 'onLogout'
    @

  summary:->
    $('.block').hide()
    if App.model.get 'Chip_id'
      $('nav').show()
      $('.main').show()
    else
      $('nav').hide()
      $('.login').show()
    @

  config:->
    model = @Forms.config.model
    @showPage 'config' , (fn)=>
      model.fetch()
      model.on 'sync', ->
        fn()
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
    $('.block').hide()
    $('.devices').show()
    console.log 'device:', id
    # device = new Models.Device(id:id)
    # device.fetch()

  tools:()->
    @showPage 'tools'

  showPage: (name, fn)->
    $('.block').hide()
    if fn
      $('.loading').show()
      fn ()->
        $('.loading').hide()
        $( '.' + name).show()
    else
      $( '.' + name).show()



App.router = new App.Router()

Backbone.history.start();
