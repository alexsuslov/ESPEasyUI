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
 * [Device model]
###
Models.Device = Models.Config.extend
  url: ->
    id = @get 'id'
    apiPrefix + "device?index=#{id}"


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
  url: apiPrefix + "devices"

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
  tBody: '#devices-list'
  serializeData: (data)->
    data.row.value = data.row.Tasks.map (task)->
      "#{task.TaskDeviceValueName}: #{task.TaskDeviceValue}"
    data

###*
 * [Device view]
###
Views.Device = Views.Main.extend
  template:_.template $('#Devices').html()
