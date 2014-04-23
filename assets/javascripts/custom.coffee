jQuery ->
  jQuery(".page-short-url-form .form .input-short-url").keydown (event)->
    if event.which == 13
      jQuery(".page-short-url-form button.submit-short-url").click()

  jQuery(".page-short-url-form .result .input-short-url").click ->
    jQuery(this).select()
    
  jQuery(".page-short-url-form .result .input-long-url").click ->
    jQuery(this).select()

  jQuery(".page-short-url-form button.submit-short-url").click ->
    long_url = jQuery(".page-short-url-form .form .input-short-url").val()
    jQuery.ajax
      url: "/parse"
      type: "POST"
      dataType: "json"
      data:
        long_url: long_url
      statusCode:
        200: (res)->
          short_url = res.short_url
          long_url = res.long_url
          $short_url_dom = jQuery(".page-short-url-form .result .input-short-url")
          $short_url_dom.val(short_url)
          $long_url_dom = jQuery(".page-short-url-form .result .input-long-url")
          $long_url_dom.val(long_url)
          jQuery(".page-short-url-form .link-download").attr("href", res.qrcode)
          jQuery(".page-short-url-form .img-qrcode").attr("src", res.qrcode)

          jQuery(".page-short-url-form .result").removeClass("hide")
          jQuery(".page-short-url-form .result .error").addClass("hide")
          jQuery(".page-short-url-form .result .short-url").removeClass("hide")
          jQuery(".page-short-url-form .result .long-url").removeClass("hide")
          jQuery(".page-short-url-form .result .qrcode").removeClass("hide")
        500: (ajax)->
          error = ajax.responseJSON.error
          jQuery(".page-short-url-form .result .error").html(error)
          jQuery(".page-short-url-form .result").removeClass("hide")
          jQuery(".page-short-url-form .result .error").removeClass("hide")
          jQuery(".page-short-url-form .result .short-url").addClass("hide")
          jQuery(".page-short-url-form .result .long-url").addClass("hide")
