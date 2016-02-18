###*
 * Main module
 * @author AlexSuslov<suslov@me.com>
 * @created 2016-02-18
###
'use strict'

apiPrefix = "http://10.0.1.32/api/"

App =
  Views : {}
  Models : {}

Views = App.Views
Models = App.Models

# replace bb sysnc
Backbone._sync = Backbone.sync
Backbone.sync = (method, model, options) ->
  beforeSend = options.beforeSend
  options = options or {}
  if method == 'update' or method == 'delete' or method == 'patch'
    options.beforeSend = (xhr) ->
      xhr.setRequestHeader 'X-HTTP-Method-Override', method
      if beforeSend
        beforeSend.apply this, arguments
      method = 'create'
      return

  Backbone._sync method, model, options



App.Views.Menu = Backbone.View.extend
  template:_.template $('#Nav').html()
  render:->
    @$el.html(@template())
    @

Models.Config = Backbone.Model.extend
  url:apiPrefix + "config"

Models.Hardware = Models.Config.extend
  url:apiPrefix + "hardware"

Views.Main = Backbone.View.extend
  initialize:->
    unless @model
      @render()
    else
      @model.fetch()
    @model.on 'sync', =>
      @render()
    @

  select: ->
    if @model
      @$el.find('select').forEach (s)=>
        name = $(s).attr('name')
        val = @model.get $(s).attr('name') unless name is undefined
        unless val is undefined
          @$el.find("select[name='#{name}'] option[value='#{val}']").attr("selected", "selected")
    @

  render: ->
    @menu = new App.Views.Menu()
    @$el.html @menu.render().el
    # console.log @template @model.toJSON()
    @$el.append(@template( if @model then @model.toJSON() else {} )) if @template
    @select()
    @onRendered() if @onRendered
    @
  onRendered: ->
    @


Views.Config = Views.Main.extend
  model: new Models.Config()
  template: _.template $('#Config').html()
  onRendered: ->
    console.log 'Config'
    @

Views.Hardware = Views.Main.extend
  model: new Models.Hardware()
  template: _.template $('#Hardware').html()
  onRendered: ->
    console.log 'Hardware'
    @

Views.Devices = Views.Main.extend
  template:_.template $('#Devices').html()
  onRendered: ->
    console.log 'Devices'

Views.Tools = Views.Main.extend
  template:_.template $('#Tools').html()
  onRendered: ->
    console.log 'Tools'
