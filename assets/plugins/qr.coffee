create_XMLHttpRequest = -> 
    try
        #IE高版本创建XMLHTTP
        return new ActiveXObject("Msxml2.XMLHTTP");
    catch E
        try
            #IE低版本创建XMLHTTP
            return new ActiveXObject("Microsoft.XMLHTTP");
        catch E
            #兼容非IE浏览器，直接创建XMLHTTP对象
            return new XMLHttpRequest();

win_load = ->
    arcode_eles = document.querySelectorAll("div[rel='qrcode']")
    for ele in arcode_eles
        long_url = ele.attributes["data-url"].value
        xml_hr = create_XMLHttpRequest()
        xml_hr.open("post", 'http://s.4ye.me/parse', true);
        xml_hr.setRequestHeader("Content-Type","application/x-www-form-urlencoded"); 
        #指定响应函数
        xml_hr.onreadystatechange = ->
            if xml_hr.readyState == 4
                if xml_hr.status == 200
                    text = xml_hr.responseText;
                    data = eval("(" + text + ")");
                    img = document.createElement("img");
                    img.src = data.qrcode
                    ele.parentNode.insertBefore(img, ele)
                    ele.remove()
        xml_hr.send("long_url=#{long_url}");


if document.attachEvent
  window.attachEvent('onload', win_load)
else
  window.addEventListener('load', win_load, false)

