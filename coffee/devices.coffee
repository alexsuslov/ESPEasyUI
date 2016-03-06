###*
 * Devices module
 * @author AlexSuslov<suslov@me.com>
 * @created 2016-02-18
###

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
    apiPrefix + "?q=4&index=" +  @get 'id'


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

Collections.Tasks = Backbone.Collection.extend()
  # url: apiPrefix + "?q=11"


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

  getTemplate:(fn)->
    $.ajax
      url:apiPrefix + "?q=10&index=" + @model.get 'id'
      complete:(jqXHR)=>
        json =  JSON.parse jqXHR.response
        @trigger 'template'
        fn json.template if fn
    @

  onRendered: ->
    console.log 'on render'
    @getTemplate (template)=>
      tpl = _.template template
      console.log $('.deviceForm')
      $('.deviceForm').append tpl data: @model.toJSON()
    @
