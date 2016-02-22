###*
 * Main module
 * @author AlexSuslov<suslov@me.com>
 * @created 2016-02-18
###
'use strict'

App =
  Views : {}
  Models : {}
  Collections: {}

Views = App.Views
Models = App.Models
Collections = App.Collections

###
 __  __           _      _
|  \/  | ___   __| | ___| |___
| |\/| |/ _ \ / _` |/ _ \ / __|
| |  | | (_) | (_| |  __/ \__ \
|_|  |_|\___/ \__,_|\___|_|___/
###

###*
 * [Config model]
###
Models.Config = Backbone.Model.extend
  url:apiPrefix + "config"
  initialize:->
    @on 'error', ->
      Backbone.trigger 'onLogout'
    @on 'save', =>
      @save( {}, type: 'post', data: @data, contentType: false, processData: false,)
    @
###*
 * [Main model]
###
Models.Main = Models.Config.extend
  url:apiPrefix + "auth"
  initialize:->
    @on 'error', ->
      Backbone.trigger 'onLogout'
    @on 'change:Chip_id', ->
      Backbone.trigger 'onLogin'
    @on 'save', =>
      @save( {}, type: 'post', data: @data, contentType: false, processData: false,)
    @

###*
 * [Hardware model]
###
Models.Hardware = Models.Config.extend
  url:apiPrefix + "hardware"


###*
 * [Device model]
###
Models.Device = Models.Config.extend
  url: ->
    id = @get 'id'
    apiPrefix + "device?index=#{id}"


###*
 * [Advanced model]
###
Models.Advanced = Models.Config.extend
  url: url:apiPrefix + "advanced"
###*
 * [Command model]
###
Models.Command = Models.Config.extend
  url: url:apiPrefix + "command"



###
  ____      _ _           _   _
 / ___|___ | | | ___  ___| |_(_) ___  _ __  ___
| |   / _ \| | |/ _ \/ __| __| |/ _ \| '_ \/ __|
| |__| (_) | | |  __/ (__| |_| | (_) | | | \__ \
 \____\___/|_|_|\___|\___|\__|_|\___/|_| |_|___/
###

###*
 * [Devices collection]
###
Collections.Devices = Backbone.Collection.extend
  url:apiPrefix + "devices"

###*
 * [Log collection]
###
Collections.Log = Backbone.Collection.extend
  url:apiPrefix + "log"

###*
 * [Commands collection]
###
Collections.Commands = Backbone.Collection.extend

###*
 * [I2C collection]
###
Collections.I2C = Backbone.Collection.extend
  url:apiPrefix + "i2c"


###
__     ___
\ \   / (_) _____      _____
 \ \ / /| |/ _ \ \ /\ / / __|
  \ V / | |  __/\ V  V /\__ \
   \_/  |_|\___| \_/\_/ |___/
###

###*
 * [Main view]
 * Simple Form view prototype
###
Views.Main = Backbone.View.extend
  template: _.template $('#Main').html()
  initialize:->
    if @model
      @model.on 'sync', =>
        @render()
    @

  events:
    'submit form': 'submit'

  submit:->
    console.log 'submit'
    @model.data = @$el.find('form').serialize()
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
    @$el.html(@template( if @model then data:@model.toJSON() else {data:{}} )) if @template
    @select()
    @onRendered() if @onRendered
    @
  onRendered: ->
    @

###*
 * Config View
###
Views.Config = Views.Main.extend
  model: new Models.Config()
  template: _.template $('#Config').html()

###*
 * Auth View
###
Views.Auth = Views.Main.extend
  template: _.template $('#Login').html()

###*
 * Advanced View
###
Views.Advanced = Views.Main.extend
  model: new Models.Advanced()
  template: _.template $('#advanced').html()


###*
 * [Hardware View]
###
Views.Hardware = Views.Main.extend
  model: new Models.Hardware()
  template: _.template $('#Hardware').html()

###*
 * [Devices view]
 * Collection list prototype
###
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


###*
 * [Log view]
###
Views.Log = Views.Devices.extend
  template    : _.template $('#Log').html()
  templateRow : _.template $('#LogRow').html()
  collection  : new Collections.Log()


###*
 * [Device view]
###
Views.Device = Views.Main.extend
  template:_.template $('#Devices').html()


###*
 * [wifi list view]
###
Views.Wifi = Views.Devices.extend
  template:_.template $('#Wifi').html()
  templateRow:_.template $('#WifiRow').html()


###*
 * [I2c list view]
###
Views.I2C = Views.Devices.extend
  template:_.template $('#I2c').html()
  templateRow:_.template $('#I2cRow').html()
  collection: new Collections.I2C()

###*
 * [Commands list view]
###
Views.Commands = Views.Devices.extend
  template:_.template $('#Commands').html()
  templateRow:_.template $('#CommandsRow').html()


###*
 * [Tools view]
###
Views.Tools = Views.Main.extend
  template:_.template $('#Tools').html()
