###*
 * Main module
 * @author AlexSuslov<suslov@me.com>
 * @created 2016-02-18
###
'use strict'

App = Views : {}
Views = App.Views


App.Views.Menu = Backbone.View.extend
  template:_.template $('#Nav').html()
  render:->
    @$el.html(@template())
    @


Views.Main = Backbone.View.extend
  initialize:->
    @render()
    @

  render: ->
    @menu = new App.Views.Menu()
    @$el.html @menu.render().el
    @$el.append(@template()) if @template
    @onRendered() if @onRendered
    @
  onRendered: ->
    console.log 'Main'
    @


Views.Config = Views.Main.extend
  template: _.template $('#Config').html()
  onRendered: ->
    console.log 'Config'
    @

Views.Hardware = Views.Main.extend
  template: _.template $('#Hardware').html()
  onRendered: ->
    console.log 'Hardware'
    @

Views.Devices = Views.Main.extend
  template:_.template $('#Devices').html()
  onRendered: ->
    console.log 'Devices'

Views.Tools = Views.Main.extend
  template:_.template $('#Tools').html()
  onRendered: ->
    console.log 'Tools'
