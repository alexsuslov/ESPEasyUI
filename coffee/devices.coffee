###*
 * Devices module
 * @author AlexSuslov<suslov@me.com>
 * @created 2016-02-18
###
'use strict'

String.prototype.replaceAll = (search, replace)->
  @split(search).join(replace)

###
 __  __           _      _
|  \/  | ___   __| | ___| |___
| |\/| |/ _ \ / _` |/ _ \ / __|
| |  | | (_) | (_| |  __/ \__ \
|_|  |_|\___/ \__,_|\___|_|___/
###

###*
 * [Device model]
###
Models.Device = Models.Config.extend
  url: ->
    id = @get 'id'
    apiPrefix + "?q=4&index=#{id}"


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
  url: apiPrefix + "?q=3"

Collections.Tasks = Backbone.Collection.extend
  url: apiPrefix + "?q=11"


###
__     ___
\ \   / (_) _____      _____
 \ \ / /| |/ _ \ \ /\ / / __|
  \ V / | |  __/\ V  V /\__ \
   \_/  |_|\___| \_/\_/ |___/
###

###*
 * [Devices view]
###
Views.Devices = Views.Collection.extend
  collection  :new Collections.Devices()
  template    : _.template $('#Devices').html()
  templateRow : _.template $('#DevicesRow').html()
  tBody       : '#devices-list'
  el          : '.devices'
  serializeData: (data)->
    data.row.value = data.row.Tasks.map (task)->
      "#{task.Name}: #{task.Number}"
    data

###*
 * [Device view]
###
Views.Device = Views.Main.extend
  template: _.template $('#Device').html()
  templateOption:  _.template '<option value="<%= o.Number %>"><%= o.Name %></option>'
  model: new Models.Device()
  el:'.device'
  events:
    'submit form': 'submit'
    'change [name="taskdevicenumber"]': 'taskdevicenumber'


  taskdevicenumber:(e)->
    e.preventDefault()

    @model.data = @deSerialize [
      {name:'taskdevicenumber', value:$(e.currentTarget).val()}
      {name:'edit', value:"1"}
    ]
    @model.trigger 'save'

    false
  getHtmlByName:(name, i)->
    model = @model.toJSON()
    if Object.keys(model).indexOf(name) > -1 and model[name] isnt '-1'
      i = '' if i is undefined
      throw new Error '#' + name + ' error id' if  $('#' + name).html() is null
      $('#' + name).html().replaceAll('{{i}}', i)
    else
      ""


  onRendered: ->
    model = @model.toJSON()
    console.log  model
    html = [
      @getHtmlByName('taskdevicename')
      @getHtmlByName('taskdevicetimer')
      @getHtmlByName('taskdeviceid')
      @getHtmlByName('taskdeviceport')

      @getHtmlByName('plugin_012_adr')
      @getHtmlByName('plugin_012_size')
      @getHtmlByName('plugin_005_dhttype')
      @getHtmlByName('plugin_023_adr')
      @getHtmlByName('plugin_023_rotate')
      @getHtmlByName('plugin_025_gain')

      @getHtmlByName('Plugin_012_template', '1')
      @getHtmlByName('Plugin_012_template', '2')
      @getHtmlByName('Plugin_012_template', '3')
      @getHtmlByName('Plugin_012_template', '4')

      @getHtmlByName('Plugin_023_template', '1')
      @getHtmlByName('Plugin_023_template', '2')
      @getHtmlByName('Plugin_023_template', '3')
      @getHtmlByName('Plugin_023_template', '4')
      @getHtmlByName('Plugin_023_template', '5')
      @getHtmlByName('Plugin_023_template', '6')
      @getHtmlByName('Plugin_023_template', '7')
      @getHtmlByName('Plugin_023_template', '8')

      @getHtmlByName('taskdevicepin', '1')
      @getHtmlByName('taskdevicepinpullup', '1')
      @getHtmlByName('taskdevicepininversed', '1')

      @getHtmlByName('taskdevicepin', '2')
      @getHtmlByName('taskdevicepin', '3')
      @getHtmlByName('taskdevicesenddata')

      @getHtmlByName('taskdeviceformula', '1')
      @getHtmlByName('taskdeviceformula', '2')

      @getHtmlByName('taskdevicevaluename', '1')
      @getHtmlByName('taskdevicevaluename', '2')
    ].join('')


    console.log html
    # App.tasks.toJSON().forEach (task)=>
    #   @$el.find('select.tasks').append @templateOption o:task
    # task = @model.get( 'taskdevicenumber')
    # template = _.template $( '[task="' + task + '"]' ).html()
    # form = @$el.find('form')
    # $(form).append template data: @model.toJSON()
    @
