# 准备工作

第一次运行请运行以下命令
```
bundle
cp config/env.yml.example config/env.yml
cp config/mongoid.yml.example config/mongoid.yml
```
然后打开config/env.yml，设置 aliyun oss 相关内容

# 运行

测试环境直接执行
```
rackup
```


# 网址二维码图片插件

使用方式举例
```xml
<html>
<head>
    <!-- 增加下面两个 script -->
    <script src='http://s.4ye.me/js/jquery-1.11.0.min.js'></script>
    <script src='http://s.4ye.me/plugin_js/qr_png.js'></script>
</head>
<body>
  <!-- data-url 属性为需要转换的 url -->
  <div rel='qrcode' data-url='https://github.com/mindpin/short-url'></div>
</boby>
</html>
```
