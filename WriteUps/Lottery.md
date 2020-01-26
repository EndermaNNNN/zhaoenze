# Lottery

## 解题思路：

- 首先，进入网页，发现是一个乐透彩票站点，注册甚至都不需要输入密码。

- 打开审查元素，注册，填写七个数字，然后监听服务器发回的回应，发现有一个叫“api.php”的脚本回应，再回元素界面仔细查看，发现这个网页的逻辑是这样的：

    - 首先，读取用户的输入数据，直接在浏览器页面检验是否为7个数字，检验完毕后调用一个叫 `buy.js` 的脚本，把这些数据 **打包成json** 发给 `api.php` 作进一步处理：

        ```javascript
        function buy(){
        $('#wait').show();
        $('#result').hide();
        var input = $('#numbers')[0];
        if(input.validity.valid){
            var numbers = input.value;
            $.ajax({
            method: "POST",
            url: "api.php",
            dataType: "json",
            contentType: "application/json", 
            data: JSON.stringify({ action: "buy", numbers: numbers })
            }).done(function(resp){
                if(resp.status == 'ok'){
                    show_result(resp);
                } else {
                    alert(resp.msg);
                }
            })
        } else {
            alert('invalid');
        }
        $('#wait').hide();
        }
        ```

    - "api.php"判断json串对应元素中有几个数字中标，然后把结果返回给 `buy.js` 中的 `resp` ，用 `show_result()` 进行输出处理。

    - 看到这里，我尝试用XSS和模板注入，发现均没有效果，修改页面元素强行修改传参格式也无法影响到 `api.php` 这个文件；

    - 再尝试构建 包含命令语句的 json文件，内容如下：

        ```json
        {"action":"buy","numbers":"1326547"}
        {"action":"buy","numbers":"1326547 && ls"}
        ```

        服务器回应：
        ```json
        {
        "status": "error",
        "msg": "please post json data"
        }
        ```

    - 这条路也走不通，最后只剩查看robots.txt，页面显示：

        ```
        User-agent: *
        Disallow: /.git/`
        ```

        不明白这个disallow里面的东西是什么意思，只好上网搜。

    - 上网看了一下，明白了，需要用githack拿到/.git里面的东西，[githack](https://pypi.org/project/githack/)下载方法：

        `pip install githack`

    - 下载之后运行，发现报错“无效目录名称”，尚未找到解决办法，明天解决。