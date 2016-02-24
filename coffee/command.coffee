###*
 * Devices module
 * @author AlexSuslov<suslov@me.com>
 * @created 2016-02-18
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
 * [Commands collection]
###
Collections.Commands = Backbone.Collection.extend
  model: Models.Command


###
__     ___
\ \   / (_) _____      _____
 \ \ / /| |/ _ \ \ /\ / / __|
  \ V / | |  __/\ V  V /\__ \
   \_/  |_|\___| \_/\_/ |___/
###

###*
 * [Commands list view]
###
Views.Commands = Views.Collection.extend
  collection: new Collections.Commands()
  model: new Models.Command()
  template:_.template $('#Commands').html()
  templateRow:_.template $('#CommandsRow').html()
  tBody: '#commands-list'
  el:'.command'
  events:
    'submit form': 'submit'

  initialize:->
    @model.on 'change:resp', =>
      @collection.add @model
      @


  submit:->
    @model.data = @$el.find('form').serialize()
    @model.trigger('save')
    false
