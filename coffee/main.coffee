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
 * [Main model]
###
# console.log apiPrefix
Models.Main = Backbone.Model.extend
  url: apiPrefix
  initialize:->
    @on 'error', ->
      Backbone.trigger 'locked'

    @on 'change:Chip_id', ->
      Backbone.trigger 'unLocked'

    @on 'save', =>
      @save( {}, type: 'post', data: @data, contentType: false, processData: false,)
    @
###*
 * [Config model]
###
Models.Config = Backbone.Model.extend
  url: apiPrefix + "config"
  initialize:->
    @on 'error', ->
      Backbone.trigger 'locked'

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
  ipInputs: []
  initialize:->
    if @model
      @model.on 'sync', =>
        @render()
    @

  events:
    'submit form': 'submit'

  deSerialize:(data)->
    $.param data

  submit:->
    @model.data = @deSerialize @$el.find('form').serializeArray()
    # console.log @model.data
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
    @
  onRendered: ->
    @

###*
 * Config View
###
Views.Config = Views.Main.extend
  model     : new Models.Config()
  template  : _.template $('#Config').html()
  templates : ['#alone','#DomoticzHTTP']
  el        : '.config'
  deSerialize:(data)->
    data.map (val)=>
      if val.name in @ipInputs
        val.value = val.value.replace( /\./g,',')
    $.param data
  events:
    'submit form': 'submit'
    'change [name="protocol"]': 'protocol'

  protocol:(e)->
    @model.set 'protocol', "" + e.currentTarget.selectedIndex
    @onRendered()
    # console.log el.options[el.selectedIndex]

    # console.log e.currentTarget.selectedIndex
    false
  onRendered: ->
    # get #Protocol element
    $el = @$el.find('#Protocol')
    # get template name
    name = @templates[ parseInt( @model.get( 'protocol') ) ]
    console.log name
    # create template func
    template = _.template $(name).html()
    # render
    $el.html template data:@model.toJSON()
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
 * [Tools view]
###
Views.Tools = Views.Main.extend
  template:_.template $('#Tools').html()
  el:'.tools'
