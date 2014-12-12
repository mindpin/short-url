jQuery ->
  jQuery("div[rel='qrcode']").each ->
    qrcode_ele = jQuery(this)
    long_url = qrcode_ele.data("url")
    jQuery.post 'http://s.4ye.me/parse',
      long_url: long_url,
      (data)->
        jQuery("<img src='#{data.qrcode}'/>").replaceAll(qrcode_ele)
