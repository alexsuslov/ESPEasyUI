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
  Collections: {}

Views = App.Views
Models = App.Models
Collections = App.Collections

Models.Config = Backbone.Model.extend
  url:apiPrefix + "config"
  initialize:->
    @on 'save', =>
      @save( {}, type: 'post', data: @data, contentType: false, processData: false,)
    @

Models.Device = Models.Config.extend
  url: ->
    id = @get 'id'
    apiPrefix + "device?index=#{id}"

Collections.Devices = Backbone.Collection.extend
  url:apiPrefix + "devices"

Models.Hardware = Models.Config.extend
  url:apiPrefix + "hardware"

Views.Main = Backbone.View.extend
  initialize:->
    if @model
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
    @$el.html(@template( if @model then @model.toJSON() else {} )) if @template
    @select()
    @onRendered() if @onRendered
    @
  onRendered: ->
    @


Views.Config = Views.Main.extend
  model: new Models.Config()
  template: _.template $('#Config').html()

Views.Hardware = Views.Main.extend
  model: new Models.Hardware()
  template: _.template $('#Hardware').html()


Views.Devices = Backbone.View.extend
  template    : _.template $('#Devices').html()
  templateRow : _.template $('#DevicesRow').html()

  collection  :new Collections.Devices()
  initialize  :->
    @collection.on 'update', => @render()
    @
  serilizeData: (data)->
    data.device.value = data.device.Tasks.map (task)->
      "#{task.TaskDeviceValueName}: #{task.TaskDeviceValue}"
    data
  render      :->

    @$el.html @template()
    $tbody = @$el.find('tbody')
    @collection.toJSON().forEach (device)=>
      $tbody.append @templateRow( @serilizeData device:device)
    @


Views.Device = Views.Main.extend
  template:_.template $('#Devices').html()

Views.Tools = Views.Main.extend
  template:_.template $('#Tools').html()
