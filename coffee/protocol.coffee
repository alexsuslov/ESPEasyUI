###*
 * Protocols module
 * @author AlexSuslov<suslov@me.com>
 * @created 2016-02-18
###

###
 __  __           _      _
|  \/  | ___   __| | ___| |___
| |\/| |/ _ \ / _` |/ _ \ / __|
| |  | | (_) | (_| |  __/ \__ \
|_|  |_|\___/ \__,_|\___|_|___/
###

###*
 *

Account: "0"
MQTT: "0"
Name: "Domoticz HTTP"
Number: "1"
Password: "0"
defaultPort: "8080"
###

Protocol = Backbone.Model.extend
  MQTT: $('#ProtocolMQTT').html()
  Account: $('#ProtocolAccount').html()
  Password: $('#ProtocolPassword').html()
  idAttribute: "Number"

  getTemplate: ->
    unless @get('clean')
      [
        $('#ProtocolHost').html()
        if @get('Account') is '1' then @Account else ''
        if @get('Password') is '1' then @Password else ''
      ].join('')

###
  ____      _ _           _   _
 / ___|___ | | | ___  ___| |_(_) ___  _ __  ___
| |   / _ \| | |/ _ \/ __| __| |/ _ \| '_ \/ __|
| |__| (_) | | |  __/ (__| |_| | (_) | | | \__ \
 \____\___/|_|_|\___|\___|\__|_|\___/|_| |_|___/
###
###*
 * Protocols
###
Protocols = Backbone.Collection.extend
  model: Protocol
  idAttribute: 'Number'

protocols = new Protocols(
  clean: true
  Name: "- Standalone -"
  Number: "0"
)
App.protocols = protocols

