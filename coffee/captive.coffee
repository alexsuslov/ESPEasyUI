# first start

$ ->
  # api = 'http://10.0.1.32/api/wifiscanner'
  # config_api = 'http://10.0.1.32/api/wifiscanner'
  api = '/api/wifiscanner'
  config_api= '/api/config'
  timeout = 10

  # templates object
  reSSID = new RegExp('<%= row.ssid %>' , 'g')
  reRSSI = new RegExp('<%= row.ssid %>' , 'g')

  tpl = (data)->
    data.sort (a,b)->
      if a.rssi > b.rssi then -1 else 1

    html  = $('#row').html()
    html.replace reSSID, data.ssid
      .replace reRSSI, data.rssi

  $('.container').html($('#captive').html())

  # form
  wifinet =
    ssid: ''
    v: ->
      @e.off 'submit'
      @e.on 'submit', ->
        data =
          ssid: $('#SSID').val()
          key: $('#KEY').val()
        if $('#SSID').val() and $('#KEY').val()
          $.post config_api, data, (redirect, status, xhr)->
            if xhr.status != 202
              console.log 'error: status', xhr.status
            else
              $('.cfg').hide()
              setInterval (->
                if timeout
                  $('h1').html("Redirected to <a href='#{redirect}'>#{redirect}</a> in #{timeout} sec.")
                  timeout -= 1
                else
                  window.location = redirect
              ), 1000
        false
      this

    i: (e) ->
      @e = e if e
      @r()

    r: ->
      $('#SSID').val(@ssid)
      $('#KEY').focus()
      @v()

    s: (net) ->
      @ssid = net.ssid
      @r()

  wifinet.i $('form')
  # git list and render main form
  $.getJSON api, (data) ->
    # data is [wifi netwok]
    if data.length
      data.forEach (net) ->
        # create network row
        row = $ tpl net
        # add click event to network row (
        row.on 'click', ->
          wifinet.s net
          false
        # add row to list
        $('.list-group').append row

