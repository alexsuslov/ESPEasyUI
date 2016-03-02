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
 * [Model description]
###
Models.Model = Backbone.Model.extend
  initialize:->
    @on 'error', ->
      Backbone.trigger 'locked'

    @on 'save', =>
      @save( {}, type: 'post', data: @data, contentType: false, processData: false,)
    @

###*
 * [Main model]
###
Models.Main = Models.Model.extend
  url: apiPrefix + '?q=0'
  initialize:->
    @on 'error', ->
      Backbone.trigger 'locked'

    @on 'change:Chip_id', ->
      Backbone.trigger 'unLocked'

    @on 'save', =>
      @save( {}, type: 'post', data: @data, contentType: false, processData: false,)
    @

###*
 * [Hardware model]
###
Models.Hardware = Models.Model.extend
  url:apiPrefix + "?q=2"

###*
 * [Advanced model]
###
Models.Advanced = Models.Model.extend
  url: apiPrefix + "?q=5"


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
  url:apiPrefix + "?q=6"

###*
 * [Wifi collection]
###
Collections.Wifi = Backbone.Collection.extend
  url:apiPrefix + "?q=7"
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
  ipInputs: []
  initialize:->
    if @model
      @model.on 'sync', =>
        @render()
    @

  events:
    'submit form': 'submit'

  deSerialize:(arr)->
    object = arr.reduce (obj, el )->
      obj[el.name] = el.value
      obj
    , {}
    # checkbox
    @$el.find('input[type="checkbox"]').forEach (s)=>
      $s = $ s
      object[name]="on" if $s.attr('checked') is 'checked'

    $.param Object.keys(object).map (name)->
      name:name
      value: object[name]

  submit:->
    @model.data = @deSerialize @$el.find('form').serializeArray()
    # console.log @model.data
    @model.trigger('save')
    false

  checkbox: ->
    if @model
      @$el.find('input[type="checkbox"]').forEach (s)=>
        name = $(s).attr('name')
        val = @model.get name unless name is undefined
        if val is "1"
          $(s).attr 'checked', 'checked'
    @
  select: ->
    if @model
      @$el.find('select').forEach (s)=>
        name = $(s).attr('name')

        val = @model.get name unless name is undefined
        unless val is undefined
          @$el.find("select[name='#{name}'] option[value='#{val}']").attr("selected", "selected")
    @

  ip: ->
    if @model
      @ipInputs = []
      @$el.find('input.ip').forEach (s)=>
        @ipInputs.push
        $el= $(s)
        @ipInputs.push $el.attr('name')
        $el.val $el.val().replace( /,/g,'.')
    @

  render: ->

    @$el.html(@template( if @model then data:@model.toJSON() else {data:{}} )) if @template
    @onRendered() if @onRendered
    @select()
    @ip()
    @checkbox()
    @
  onRendered: ->
    @


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
  el:'.advanced'
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
 * [Tools view]
###
Views.Tools = Views.Main.extend
  template:_.template $('#Tools').html()
  el:'.tools'
