###*
 * Router module
 * @author AlexSuslov<suslov@me.com>
 * @created 2016-02-18
###
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
    tools    : new App.Views.Tools().render()
    log      : new App.Views.Log()
    login    : new App.Views.Unlock(model:App.model).render()
    main     : new App.Views.Main(model:App.model)
    config   : new App.Views.Config()
    hardware : new App.Views.Hardware()
    devices  : new App.Views.Devices()
    wifi     : new App.Views.Wifi()

  initialize:->
    Backbone.on 'locked', =>
      $('.block').hide()
      $('.loading').hide()
      $('.login').show()

    Backbone.on 'unLocked', =>
      @Forms.main.render()
      @showPage 'main'
    @

  summary:->
    model= App.model
    @showPage 'main' , (fn)=>
      model.on 'sync', ->fn()
      model.fetch()
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



  config:->
    model = @Forms.config.model
    @showPage 'config' , (fn)=>
      model.fetch()
      model.on 'sync', ->
        fn()
    @

  hardware:->
    model = @Forms.hardware.model
    @showPage 'hardware' , (fn)=>
      model.on 'sync', ->
        # console.log model.toJSON()
        fn()
      model.fetch()
    @

  devices:->
    col = @Forms.devices.collection
    @showPage 'devices' , (fn)=>
      col.on 'sync', ->fn()
      col.fetch()
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
