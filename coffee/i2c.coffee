###*
 * Devices module
 * @author AlexSuslov<suslov@me.com>
 * @created 2016-02-18
###
'use strict'

###
  ____      _ _           _   _
 / ___|___ | | | ___  ___| |_(_) ___  _ __  ___
| |   / _ \| | |/ _ \/ __| __| |/ _ \| '_ \/ __|
| |__| (_) | | |  __/ (__| |_| | (_) | | | \__ \
 \____\___/|_|_|\___|\___|\__|_|\___/|_| |_|___/
###

###*
 * [I2C collection]
###
Collections.I2C = Backbone.Collection.extend
  url:apiPrefix + "i2c"


###
__     ___
\ \   / (_) _____      _____
 \ \ / /| |/ _ \ \ /\ / / __|
  \ V / | |  __/\ V  V /\__ \
   \_/  |_|\___| \_/\_/ |___/
###

###*
 * [I2c list view]
###
Views.I2c = Views.Collection.extend
  template:_.template $('#I2c').html()
  templateRow:_.template $('#I2cRow').html()
  collection: new Collections.I2C()
  tBody: '#i2c-list'
