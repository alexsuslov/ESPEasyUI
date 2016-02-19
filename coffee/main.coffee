###*
 * Main module
 * @author AlexSuslov<suslov@me.com>
 * @created 2016-02-18
###
'use strict'

apiPrefix = "http://10.0.1.32/api/"

$.fn.serializeObject = ->
  obj = {}
  @serializeArray().forEach (v)->
    obj[v.name]= v.value
  obj

App =
  Views : {}
  Models : {}

Views = App.Views
Models = App.Models



App.Views.Menu = Backbone.View.extend
  template:_.template $('#Nav').html()
  render:->
    @$el.html(@template())
    @

Models.Config = Backbone.Model.extend
  url:apiPrefix + "config"
  initialize:->
    @on 'save', =>
      @save( {}, type: 'post', data: @data, contentType: false, processData: false,)
    @


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

  events:
    'submit form': 'submit'

  submit:->
    @model.data = @$el.find('form').serialize()
    console.log '@model.data',@model.data
    @model.trigger('save')
    false

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
