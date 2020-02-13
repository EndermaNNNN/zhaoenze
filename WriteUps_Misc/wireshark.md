# wireshark

## 解题思路：

- 仍然考察流量分析，说实话流量分析题是真的有点难找，现在网页上下载附件，用wireshark打开。

- 打开后，仔细看HTTP协议部分，发现是服务器后台和客户之间互相上传下载图片的互动，把其中的服务器端回复的html文件重新保存打开一下：

    ```html
    <!DOCTYPE html>
    <html lang="zh-cn"><head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>................../..................(.........)...... - .................. - ........................</title>
        <meta name="keywords" content="......,............,............,...............,..................,..................,............,............,.....................,..............................,.............................." />
        <meta name="description" content=".........................................................................................................................................................................................................................................................................................." />
        <!-- Bootstrap -->
        <link href="http://tools.jb51.net/static/skin/css/bootstrap.min.css" rel="stylesheet">
        <!-- Styles -->
        <link href="http://tools.jb51.net/static/skin/css/theme.css" rel="stylesheet">
        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
        <script src="http://tools.jb51.net/static/skin/js/html5shiv.min.js"></script>
        <script src="http://tools.jb51.net/static/skin/js/respond.min.js"></script>
        <![endif]-->
        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <!--[if !IE]> -->
        <script type="text/javascript">
            window.jQuery || document.write("<script src='http://tools.jb51.net/static/skin/js/jquery.min.js'>"+"<"+"/script>");
        </script>
        <!-- <![endif]-->
        <!--[if IE]>
        <script type="text/javascript">
            window.jQuery || document.write("<script src='http://tools.jb51.net/static/skin/js/jquery1x.min.js'>"+"<"+"/script>");
        </script>
        <![endif]-->
    </head>
    <body>
    <header>
        <nav class="navbar navbar-default" role="navigation">
            <div class="container-fluid"><!-- container-fluid -->
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                        <span class="sr-only">......</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="http://tools.jb51.net/">........................</a>
                </div>
                <div class="collapse navbar-collapse">
                    <ul class="nav navbar-nav">
                        <li><a href="http://tools.jb51.net/#home">......</a></li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">............<span class="caret"></span></a>
                            <ul class="dropdown-menu" role="menu">
                                <li><a href="http://tools.jb51.net/table" >........................</a></li>
                                <li><a href="http://tools.jb51.net/code" >............</a></li>
                                <li><a href="http://tools.jb51.net/regex" >.....................</a></li>
                                <li><a href="http://tools.jb51.net/color" >..................</a></li>
                                <li><a href="http://tools.jb51.net/transcoding" >..................</a></li>

                            </ul>
                        </li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">............<span class="caret"></span></a>
                            <ul class="dropdown-menu" role="menu">
                                <li><a href="http://tools.jb51.net/password" >...............</a></li>
                                <li><a href="http://tools.jb51.net/email" >Email............</a></li>
                                <li><a href="http://tools.jb51.net/aideddesign" >..................</a></li>

                            </ul>
                        </li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">............<span class="caret"></span></a>
                            <ul class="dropdown-menu" role="menu">
                                <li><a href="http://tools.jb51.net/jisuanqi" >...............</a></li>
                                <li><a href="http://tools.jb51.net/zhuanhuanqi" >...............</a></li>
                                <li><a href="http://tools.jb51.net/baojian" >..................</a></li>
                                <li><a href="http://tools.jb51.net/bianmin" >..................</a></li>
                                <li><a href="http://tools.jb51.net/games" >..................</a></li>

                            </ul>
                        </li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                        <li><a href="http://www.jb51.net/" target="_blank">........................</a></li>
                    </ul>
                </div><!--/.nav-collapse -->
            </div>
        </nav>
    </header>
    <div class="container-fluid"><!-- container-fluid -->


        <div class="row">

            <div class="col-md-3">

                <div class="panel panel-default">
        <span class="jbTestPos" id="adv_nav">
        </span>
                </div>

                <ul class="sidebar-menu">
                    <li><a href="http://tools.jb51.net/table" class=""><i class="fa fa-table"></i>........................</a></li>
                    <li><a href="http://tools.jb51.net/code" class=""><i class="fa fa-code"></i>............</a></li>
                    <li><a href="http://tools.jb51.net/regex" class=""><i class="fa fa-empire"></i>.....................</a></li>
                    <li><a href="http://tools.jb51.net/color" class=""><i class="fa fa-delicious"></i>..................</a></li>
                    <li><a href="http://tools.jb51.net/transcoding" class=""><i class="fa fa-cubes"></i>..................</a></li>
                    <li><a href="http://tools.jb51.net/password" class=""><i class="fa fa-compass"></i>...............</a></li>
                    <li><a href="http://tools.jb51.net/email" class=""><i class="fa fa-envelope"></i>Email............</a></li>
                    <li><a href="http://tools.jb51.net/aideddesign" class=" selected"><i class="fa fa-share-square-o"></i>..................</a></li>
                    <ul class="listbar-menu">
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/webps" class="">......PS..................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/createrobots" class="">......robots.txt..................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/ljscq" class="">.................................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/picext" class="">........................(jpg/bmp/gif/png)......</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/ipcha" class="">IP.................................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/ico_img" class="">ICO........................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/css3_boxshadow" class="">CSS3 Box Shadow(......)........................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/css3_textshadow" class="">CSS3 Text Shadow(............)........................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/css3_textstroke" class="">CSS3 Text Stroke(............)...text-fill-color(...............)............</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/css3_borderradius" class="">CSS3 border-radius(......)........................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/webkit_LinearGradients" class="">webkit......safari/Chrome...Linear Gradients(............)..................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/moz_LinearGradients" class="">Firefox...Linear Gradients (............)..................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/css3_transform" class="">CSS3 transform(......)...transform-origin(............)............</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/css_create" class="">CSS........................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/button_css" class="">......CSS........................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/txt_paiban" class="">..............................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/flipped_txt" class="">....................................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/html2markdown" class="">......HTML/MarkDown..................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/ipcalc" class="">.....................|TCP/IP.................................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/colortext" class="">................../........................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/shouxiezi" class="">...................../.....................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/ip_net_calc" class="">......IP....../.................................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/network_calc" class="">.............................................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/txt_beaut" class="">.................................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/txt_diff" class="">........................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/txt_quchong" class="">...........................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/layoutit" class="">......bootstrap...........................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/txt_caihongzi" class="">................../..............................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/txt_faguangzi" class="">...........................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/advtools" class="">....................................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/suijishu" class="">................../.....................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/tiaoxingma" class="">...............(.........)....../..................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/zh_paixu" class="">..........................................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/whois" class="">..................whois............</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/browser_info" class="">.................................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/rnd_password" class="">................../........................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/rnd_userinfo" class="">..........................................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/rnd_num" class="">...........................</a></li>
                        <li><span class=' caret-left'></span><a href="http://tools.jb51.net/aideddesign/img_add_info" class=" selected">................../..................(.........)......</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/jb51_paiban" class="">............/............/............(.....................)</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/bt2mag" class="">......BT......torrent/..............................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/bt_info" class="">......BT......torrent............/...............magnet......</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/svg_editor" class="">SVG.....................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/paixu_ys" class="">......................../....../....../....../....../..............................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/domain" class="">............/..............................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/yishuzi" class="">................../........................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/imgcut" class="">................../............</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/img_lowpoly" class="">....................................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/mkhtaccess" class="">.htaccess..............................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/js_bianli" class="">......JS..........................................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/rnd_pwd_tool" class="">.............../..............................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/rnd_mima_tool" class="">...................../........................</a></li>
                        <li><span class=''></span><a href="http://tools.jb51.net/aideddesign/vim_tool" class="">......VIM.....................</a></li>
                    </ul>
                    <li><a href="http://tools.jb51.net/jisuanqi" class=""><i class="fa fa-calculator"></i>...............</a></li>
                    <li><a href="http://tools.jb51.net/zhuanhuanqi" class=""><i class="fa fa-calculator"></i>...............</a></li>
                    <li><a href="http://tools.jb51.net/baojian" class=""><i class="fa fa-user-md"></i>..................</a></li>
                    <li><a href="http://tools.jb51.net/bianmin" class=""><i class="fa fa-user"></i>..................</a></li>
                    <li><a href="http://tools.jb51.net/games" class=""><i class="fa fa-paper-plane"></i>..................</a></li>
                </ul>


                <div class="panel panel-default">
                    <div class="panel-heading">............</div>
                    <div class="panel-body">
                        2017.8.11:................../..................(.........)..................
                    </div>
                </div>

                <div class="panel panel-default">
        <span class="jbTestPos" id="adv_side">
        </span>
                </div>
            </div>

            <div class="col-md-9">

                <ol class="breadcrumb">
                    <li><a href="http://tools.jb51.net/">......</a></li>
                    <li><a href="http://tools.jb51.net/aideddesign">..................</a></li>
                    <li><a href="http://tools.jb51.net/aideddesign/img_add_info">................../..................(.........)......</a></li>
                </ol>

                <h1 align="center" style="font-size:30px;">................../..................(.........)......</h1>
                <h2 class="alert alert-success" style="font-size:16px;">..........................................................................................................................................................................................................................................................................................</h2>
                <span class="jbTestPos" id="advtop"></span>    <hr/>
                <style>
                    .container{font-size:16px;width:1000px;margin:0 auto}.container .divider{width:100%;background:#CCC;height:1px;margin:25px 0}.container .row{min-height:2em;line-height:2em;width:100%}.container .row:before,.container .row:after{content:'\0020';display:block;overflow:hidden;visibility:hidden;width:0;height:0}.container .row:after{clear:both}.container .row{zoom:1;margin:10px 0}.container .span{float:left;display:inline;min-height:1em}.container .span:first-child{margin-left:0}.container .span:last-child{margin-right:0}.container .six{width:48%}.container input{text-align:left;border:1px solid #CCC;border-radius:5px;font-size:.98em}.container .input-text{width:95%;height:2.1em;line-height:2.1em;padding-left:5px}.container .button{border:0;border-radius:4px;outline:0;cursor:pointer;margin-bottom:10px}.container .button.small{padding:7px 10px;font-size:.95em}.container .button.large{padding:15px 25px;font-size:1.1em}.container .button.primary{color:#FFF;background:#5f90b0}.container .button.primary:hover{background:#5589ab}.container .button.success{color:#FFF;background:#4daf7c}.container .button.success:hover{background:#48a474}.container .button.danger{color:#FFF;background:#e6623c}.container .button.danger:hover{background:#e4572e}.container .alert{padding:10px;margin:0;border-radius:3px}.container .alert.primary{background:#e8eff3;border:1px #c5d7e3 solid}.container .alert.success{background:#daeee4;border:1px #b6dfca solid}.container .alert.danger{background:#fdf4f1;border:1px #f7cfc4 solid}.container .hidden,.container .hide{display:none}
                </style>
                <div class='container'>
                    <h4 class="strong">....................................</h4>
                    <div class='divider'></div>
                    <div class='row'>
                        <div class='span'>1. ......................................................</div>
                        <div class='span'>
                            <input type="file" accept="image/*" id="origin_image" onchange="importImage();" />
                        </div>
                    </div>
                    <div class='row'>
                        <div class='span'>2. ................................................</div>
                        <div class='span six'>
                            <input type="text" class="input-text" placeholder="................................................ www.jb51.net" id="secret_text" />
                        </div>
                    </div>
                    <div class='row'>
                        <div class='span'>3. ....................................</div>
                        <div class='span six'>
                            <input type="password" class="input-text" placeholder="................................................" id="secret_pwd" />
                        </div>
                    </div>
                    <div>
                        <button class='button primary small' onclick="javascript:encode()" type="button">..............................</button>
                    </div>
                    <div class="alert success">
                        <canvas id="result_image" class="hidden"></canvas>
                        <div id="encode_tip" class="strong green"></div>
                        <img id='result_image_output' />
                    </div>
                    <div class='divider'></div>
                    <h4 class="strong">....................................</h4>
                    <div class='divider'></div>
                    <div class='row'>
                        <div class='span'>1. ......................................................</div>
                        <div class='span'>
                            <input type="file" accept="image/*" id="decode_image" onchange="javascript:selectEncodeImage()" />
                        </div>
                    </div>
                    <div class='row'>
                        <div class='span'>2. ........................................................................</div>
                        <div class='span six'>
                            <input type="password" class="input-text" placeholder=".................................................................." id="decode_pwd" />
                        </div>
                    </div>
                    <div>
                        <button class='button primary small' onclick="javascript:decode()" type="button">........................</button>
                    </div>
                    <div class="alert success">
                        <canvas id="decode_result_image" class="hidden"></canvas>
                        <div class="strong" id="messageDecoded"></div>
                    </div>
                    <script src="http://tools.jb51.net/static/api/img_add_info/sjcl.js" type='text/javascript'></script>
                    <script src="http://tools.jb51.net/static/api/img_add_info/main.js" type='text/javascript'></script>
                    <div class='divider'></div>
                    <h4 class='explainer'>......DEMO......</h4>
                    <div>
                        <p>.........................................................................................................</p>
                        <p><img src="/static/api/img_add_info/demo1.png"></p>
                        <p><img src="/static/api/img_add_info/demo2.png"></p>
                        <p>...............https://github.com/oakes/PixelJihad</p>
                    </div>
                </div>


                <h2 class="alert alert-warning" style="text-align:center">................../..............................</h2>
                <div class="alert alert-info" style="font-size:16px;">
                    <p>.... .............................................wiki................................................................................................................................................................................................</p>
                    <p>.... ............................................................................................................................................................</p>
                    <p>.... ...........................................................................................................................~</p>
                    <p>.... .........................................................app........................................................................</p>
                </div>

                <div style="font-size:14px;border-radius: 4px; border: 2px solid #f9f7f7; color:#525050; width:95%; margin:0 auto; padding:10px; margin-top: 10px; text-align:center; line-height:30px; font-family:'............'"><p>...........................................................................<font color="red"><strong>.......................................</strong></font></p><p>...................................................</p><p><img src="http://tools.jb51.net/images/weixin.png" width="180" /></p><p style="color:#757474;">.........................................................</p></div><hr/><div class="adv-top"><span class="jbTestPos" id="advbottom"></span></div><br/><script language="javascript" src="/js/adv_bottom.js"></script><div class="well">
                    <hr />
                    <div id="SOHUCS" sid="img_add_info" ></div>
                    <script type="text/javascript">

                        /*(function(){
                        var appid = 'cysUlpBwg';
                        var conf = 'prod_307001f2f75b898226a72bcc8a87d842';
                        var width = window.innerWidth || document.documentElement.clientWidth;
                        if (width < 960) {
                        window.document.write('<script id="changyan_mobile_js" charset="utf-8" type="text/javascript" src="http://changyan.sohu.com/upload/mobile/wap-js/changyan_mobile.js?client_id=' + appid + '&conf=' + conf + '"><\/script>'); } else { var loadJs=function(d,a){var c=document.getElementsByTagName("head")[0]||document.head||document.documentElement;var b=document.createElement("script");b.setAttribute("type","text/javascript");b.setAttribute("charset","UTF-8");b.setAttribute("src",d);if(typeof a==="function"){if(window.attachEvent){b.onreadystatechange=function(){var e=b.readyState;if(e==="loaded"||e==="complete"){b.onreadystatechange=null;a()}}}else{b.onload=a}}c.appendChild(b)};loadJs("http://changyan.sohu.com/upload/changyan.js",function(){window.changyan.api.config({appid:appid,conf:conf})}); } })();
                        */
                    </script>

                </div>

            </div>


        </div> <!--end for container-->

        <div class="footer">
            <hr />
            <p align="center">Copyright &copy; 2006-2019 <a href="http://tools.jb51.net/" target="_blank">............</a>. All Rights Reserved. <a href="http://www.miibeian.gov.cn" rel=nofollow target="_blank">...ICP...14036222...</a></p>
        </div>

        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="http://tools.jb51.net/static/skin/js/bootstrap.min.js"></script>
        <!-- Sitejs -->
        <script src="http://tools.jb51.net/static/skin/js/site.min.js"></script>
        <script type="text/javascript" src="http://tools.jb51.net/js/jbLoader.js"></script>
        <script>jbLoader();</script><script class="closetag">jbLoader(true);</script>
        <script>jbLoader();</script><script class="closetag">jbLoader(true);</script>
        <script>jbLoader();</script><script class="closetag">jbLoader(true);</script>
        <script>jbLoader();</script><script class="closetag">jbLoader(true);</script>
        <div class="tongji"><script src="http://tools.jb51.net/static/skin/js/tongji.js"></script></div>
    </body>
    </html>
    ```

    用浏览器打开，发现重定位到了 `http://tools.jb51.net/` 这个网站，暂时先观望一下。

- 图片互动方面，客户总共上传了两张图片 `7782abccd82067` 和 `fd2f6f3479d1741es` （而且第二张图片是以data而非MIME或.png形式POST上传的，这个很容易漏掉）；下载了一张图片 `fd2f6f3479d1741es` ，中间穿插着申请授权和访问目录的请求，我们想办法把这两张图片都搞下来。

- 直接找到对应报文的 `Portable Network Graphics` 项，右键导出报文字节流，可以直接看到拿到的东西。

- 一张是一个钥匙图案，另一张是一个风景图（这张图上传了又下载了一遍），想到是不是要用密钥解密图片，密钥要从钥匙图片上拿。

- 这里卡住了，不知道怎么解析图片，只好看别人的wp，提到了winhex提高图片高度，提高后图片下方露出了我们期待的东西：`key:57pmYyWt`

- 拿key和图片到 `http://tools.jb51.net/` 上找图片解密工具进行解密，注意这里如果用服务器发回来的质量损失后的图片的话，是无法解密出东西的，必须拿到用户上传时候data格式的源图片才可以。解密后得到：

        图片中隐藏的信息为：flag+AHs-44444354467B5145576F6B63704865556F32574F6642494E37706F6749577346303469526A747D+AH0-

- 最后把这一长串东西用十六进制转换：

    `DDCTF{QEWokcpHeUo2WOfBIN7pogIWsF04iRjt}`

- 搞定！

## 学到的东西：

- 对大数据包一定要敏感，对POST也要敏感，不能一看到POST内容不是显式的固定格式文件就掉以轻心，很可能会有Data形式的各类文件传输。