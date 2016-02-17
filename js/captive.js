(function() {
  'use strict';
  $(function() {
    var api, config_api, reRSSI, reSSID, timeout, tpl, wifinet;
    api = '/api/wifiscanner';
    config_api = '/api/config';
    timeout = 10;
    reSSID = new RegExp('{{data.ssid}}', 'g');
    reRSSI = new RegExp('{{data.rssi}}', 'g');
    tpl = function(data) {
      var html;
      html = $('#row').html();
      return html.replace(reSSID, data.ssid).replace(reRSSI, data.rssi);
    };
    $('.container').html($('#captive').html());
    wifinet = {
      ssid: '',
      v: function() {
        this.e.off('submit');
        this.e.on('submit', function() {
          var data;
          data = {
            ssid: $('#SSID').val(),
            key: $('#KEY').val()
          };
          if ($('#SSID').val() && $('#KEY').val()) {
            $.post(config_api, data, function(redirect, status, xhr) {
              if (xhr.status !== 202) {
                return console.log('error: status', xhr.status);
              } else {
                $('.cfg').hide();
                return setInterval((function() {
                  if (timeout) {
                    $('h1').html("Redirected to <a href='" + redirect + "'>" + redirect + "</a> in " + timeout + " sec.");
                    return timeout -= 1;
                  } else {
                    return window.location = redirect;
                  }
                }), 1000);
              }
            });
          }
          return false;
        });
        return this;
      },
      i: function(e) {
        if (e) {
          this.e = e;
        }
        return this.r();
      },
      r: function() {
        $('#SSID').val(this.ssid);
        $('#KEY').focus();
        return this.v();
      },
      s: function(net) {
        this.ssid = net.ssid;
        return this.r();
      }
    };
    wifinet.i($('form'));
    return $.getJSON(api, function(data) {
      if (data.length) {
        return data.forEach(function(net) {
          var row;
          row = $(tpl(net));
          row.on('click', function() {
            wifinet.s(net);
            return false;
          });
          return $('.list-group').append(row);
        });
      }
    });
  });

}).call(this);
