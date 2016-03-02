###*
 * Cfg
 * @author AlexSuslov<suslov@me.com>
 * @created 2016-02-22
###
'use strict'

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
  templates : []
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
    @ip()
    false

  onRendered: ->
    # create select list
    $select = $('select[name="protocol"]')
    App.protocols.toJSON()
      .sort (a, b)->
        return -1 if a.Number < b.Number
        return 1
      .forEach (p)=>
        $select.append @templateRow row:p
    # create list protocol templates
    @templates = $('[type="text/x-template-protocol"]').sort( (a,b)->
      return -1 if $(a).attr('p') < $(b).attr('p')
      1
      ).map (i,v)-> '#' + v.id
    # get #Protocol element
    $el = @$el.find('#Protocol')
    proto =  @model.get( 'protocol')
    # get model
    # console.log   App.protocols.toJSON()
    model = App.protocols.get proto
    # console.log 'model', model
    # create template func
    template = _.template model.getTemplate()
    # render
    $el.html template data:@model.toJSON()
    @
