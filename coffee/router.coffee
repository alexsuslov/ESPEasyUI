###*
 * Router module
 * @author AlexSuslov<suslov@me.com>
 * @created 2016-02-18
###
App.model = new Models.Main()
App.tasks = new Collections.Tasks()

App.Router = Backbone.Router.extend
  login:false

  routes:
    advanced      : 'advanced'
    i2c           : 'i2c'
    command       : 'command'
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
    advanced : new App.Views.Advanced().render()
    tools    : new App.Views.Tools().render()
    log      : new App.Views.Log()
    login    : new App.Views.Unlock(model:App.model).render()
    main     : new App.Views.Main(model:App.model)
    config   : new App.Views.Config()
    hardware : new App.Views.Hardware()
    devices  : new App.Views.Devices()
    device    : new App.Views.Device()
    wifi     : new App.Views.Wifi()
    I2c      : new App.Views.I2c()
    command  : new App.Views.Commands().render()

  initialize:->
    Backbone.on '500', =>
      console.log 'sync error'
    Backbone.on '401', =>
      $('.block').hide()
      $('.loading').hide()
      $('.login').show()

    Backbone.on 'unLocked', =>
      @Forms.main.render()
      @showPage 'main'
    @

  i2c:->
    col = @Forms.I2c.collection
    @showPage 'i2c' , (fn)=>
      col.on 'sync', ->fn()
      col.fetch()
    @


  command:->
    $('.loading').hide()
    @showPage 'command'

  advanced:->
    model=  @Forms.advanced.model
    @showPage 'advanced' , (fn)=>
      model.on 'sync', ->fn()
      model.fetch()
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
      if App.protocols.ready
        model.fetch()
      else
        App.protocols.on 'ready', =>
          model.fetch()
      model.on 'sync', ->
        fn()
    @

  hardware:->
    model = @Forms.hardware.model
    @showPage 'hardware' , (fn)=>
      model.on 'sync', ->
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
    model = @Forms.device.model
    model.set id:id
    @showPage 'device', (fn)=>
      model.on 'sync', -> fn()

      if App.tasks?.ready
        model.fetch()
      else
        App.tasks.on 'ready', =>
          model.fetch()


  tools:()->
    @showPage 'tools'


  # show page
  # @param String name block name
  # @param function fb callback
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
# options for ajax
opt =
  # url 4 combine json
  url: apiPrefix
  async: true
  cache: true
  # cb function
  complete: (jqXHR)->
    # conver to json
    # @todo: create try / catch
    json = JSON.parse(jqXHR.response)
    # tasks list
    tasks = json.Tasks.map (task)->
      # convert list to object
      Task =
        Number: task[0]
        Type: task[1]
        VType: task[2]
        Ports: task[3]
        PullUpOption: task[4]
        InverseLogicOption: task[5]
        FormulaOption: task[6]
        ValueCount: task[7]
        Custom: task[8]
        SendDataOption: task[9]
        GlobalSyncOption: task[10]
        TimerOption: task[11]
        Name: task[12]
    # create tasks collection
    App.tasks.add tasks

    App.tasks.ready = true
    App.tasks.trigger 'ready'
    # protocols
    # use add function (App.protocols not empty)
    json.Protocols.forEach (protocol)->
      App.protocols.add protocol
    App.protocols.ready = true
    App.protocols.trigger 'ready'

# start app
Backbone.history.start();
# hide blocks
$('.block').hide()
# show loading block
$('.loading').show()
# start ajax query
$.ajax opt

$('button.collapsed').on 'click', (e)->
  classEl = $(e.currentTarget).data 'toggle'
  $('div.' + classEl).toggle()



