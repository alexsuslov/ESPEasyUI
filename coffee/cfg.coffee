###*
 * Cfg
 * @author AlexSuslov<suslov@me.com>
 * @created 2016-02-22
###


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
Models.Config = Models.Model.extend
  url: apiPrefix + "?q=1"

###
__     ___
\ \   / (_) _____      _____
 \ \ / /| |/ _ \ \ /\ / / __|
  \ V / | |  __/\ V  V /\__ \
   \_/  |_|\___| \_/\_/ |___/
###

###*
 * Config View
###

# @todo: create auto parse ip / host
# console.log 'it\'s ip' if "192.168.1.1".match  /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/


Views.Config = Views.Main.extend
  model     : new Models.Config()
  template  : _.template $('#Config').html()
  templateRow: _.template '<option value="<%= row.Number %>" ><%=row.Name%></option>'

  el        : '.config'
  deSerialize:(arr)->
    arr.map (val)=>
      if val.name in @ipInputs
        val.value = val.value.replace( /\./g,',')

    object = arr.reduce (obj, el )->
      obj[el.name] = el.value
      obj
    , {}

    if object.host.match /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/
      object.controllerip = object.host
      object.usedns = "0"

    else
      object.controllerhostname = object.host
      object.usedns = "1"


    $.param Object.keys(object).map (name)->
      name:name
      value: object[name]


  events:
    'submit form': 'submit'
    'change [name="protocol"]': 'protocol'

  protocol:(e)->
    @model.set 'protocol', "" + e.currentTarget.selectedIndex
    @onRendered()
    @select()
    @ip()
    false

  onRendered: ->
    # create select list
    $select = $('select[name="protocol"]')
    $select.empty();
    App.protocols.toJSON()
      .sort (a, b)->
        return -1 if a.Number < b.Number
        return 1
      .forEach (p)=>
        $select.append @templateRow row:p

    # get #Protocol element
    $el = @$el.find('#Protocol')
    proto =  @model.get( 'protocol')
    # get model
    # console.log   App.protocols.toJSON()
    model = App.protocols.get proto
    # create template func
    template = _.template model.getTemplate()
    # render
    $el.html template data:@model.toJSON()
    @
