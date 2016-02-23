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
      Backbone.trigger 'login'

    @on 'save', =>
      @save( {}, type: 'post', data: @data, contentType: false, processData: false,)
    @


###*
 * [Main model]
###
Models.Main = Backbone.Model.extend
  url:apiPrefix + "info"
  initialize:->
    @on 'error', ->
      Backbone.trigger 'login'

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

###*
 * [Wifi collection]
###
Collections.Wifi = Backbone.Collection.extend
  url:apiPrefix + "wifiscanner"
  model: Backbone.Model


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
  model:App.model
  el:'.main'
  initialize:->
    if @model
      @model.on 'sync', =>
        @render()
    @

  events:
    'submit form': 'submit'

  submit:->
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
  model     : new Models.Config()
  template  : _.template $('#Config').html()
  el        : '.config'


###*
 * Unlock View
###
Views.Unlock = Views.Main.extend
  template  : _.template $('#Login').html()
  model     : App.model
  el        : '.login'


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
  model     : new Models.Hardware()
  template  : _.template $('#Hardware').html()
  el        : '.hardware'


###*
 * [Collection view]
 * Collection list prototype
###
Views.Collection = Backbone.View.extend
  tBody: '.list'

  serializeData: (data)->
    # console.log data
    data
  initialize  :->
    @collection.on 'update', => @render()
    @
  render      :->
    if @template and @$el
      @$el.html @template()
      $tbody = @$el.find(@tBody)
      @collection.toJSON().forEach (device)=>
        $tbody.append @templateRow( @serializeData row:device)
    @


###*
 * [Log view]
###
Views.Log = Views.Collection.extend
  template    : _.template $('#Log').html()
  templateRow : _.template $('#LogRow').html()
  tBody       : '#log-list'
  collection  : new Collections.Log()
  el          : '.log'


###*
 * [wifi list view]
###
Views.Wifi = Views.Collection.extend
  template      : _.template $('#Wifi').html()
  templateRow   : _.template $('#WifiRow').html()
  tBody         : '#wifi-list'
  collection    : new Collections.Wifi()
  el            : '.wifi'


###*
 * [I2c list view]
###
Views.I2C = Views.Collection.extend
  template:_.template $('#I2c').html()
  templateRow:_.template $('#I2cRow').html()
  collection: new Collections.I2C()
  tBody: '#i2c-list'


###*
 * [Commands list view]
###
Views.Commands = Views.Collection.extend
  template:_.template $('#Commands').html()
  templateRow:_.template $('#CommandsRow').html()
  tBody: '#commands-list'


###*
 * [Tools view]
###
Views.Tools = Views.Main.extend
  template:_.template $('#Tools').html()
  el:'.tools'
