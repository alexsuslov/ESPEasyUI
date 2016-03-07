###*
 * Devices module
 * @author AlexSuslov<suslov@me.com>
 * @created 2016-02-18
###
$ ->
  App = window.App
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
   * [Command model]
  ###
  Models.Command = Models.Config.extend
    url: apiPrefix + "?q=9"


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
    template  : _.template Templates.Commands
    templateRow  : _.template Templates.CommandsRow
    # template:_.template $('#Commands').html()
    # templateRow:_.template $('#CommandsRow').html()
    tBody: '#commands-list'
    el:'.command'
    events:
      'submit form': 'submit'
      'click button.cmd' : 'fastCommand'

    fastCommand: (e)->
      $('input[name="c"]').val( $(e.currentTarget).attr 'def' )
      false

    initialize:->
      @model.on 'sync', =>
        @model.set 'c', @command
        @model.set 'time', new Date()
        @collection.add @model.toJSON()
        @render()
        @

    submit:->
      @command = @$el.find('form').serializeArray()[0].value
      if @command
        @model.data = @$el.find('form').serialize()
        @command = @$el.find('form').serializeArray()[0].value
        @model.trigger('save')
      false
