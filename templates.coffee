#!/usr/bin/env coffee
###
Generate js object from html templates
###
jade = require('jade')
_ = require 'lodash'

YOUR_LOCALS =
  title:'ESP Easy'
  footer: "Powered by IoT Manager team"


fn = jade.compileFile('jade/templates.jade');

html = fn(YOUR_LOCALS)

###
<script id="ProtocolAccount" type="text/xtpl"><div class="form-group"><label>Controller User:</label><input name="controlleruser" placeholder="Controller User:" value="<%= data.controlleruser %>" class="form-control"/></div></script>
###

# split scripts
#
arr =  html.split("</script>")
  .filter (item)-> true if item
  .map (item)->
    Item =
      name: item.match(/<script id="(.*?)"/)[1]
      value: item.match(/<script.*?>(.*)$/)[1]

trim  = (str)->
  str
    .replace /\n|\t|\r/, " "
    .replace /\s+/, " "

itr = (ret, item)->
  ret[item.name] = trim item.value
  ret

obj = arr.reduce itr, {}
console.log "window.Templates = #{JSON.stringify(obj)};"




