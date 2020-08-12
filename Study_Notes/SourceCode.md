# 源代码泄露

## .git 泄露：

- 漏洞利用：工具：GitHack GitHack.py http://www.am0s.com/.git/ 工具: dvcs-ripper rip-git.pl -v -u http://www.am0s.com/.git/ 

## .hg 源码泄露：

- 漏洞利用：工具：dvcs-ripperrip-hg.pl -v -u http://www.am0s.com/.hg/ 

## .DS_Store 文件泄露：

- 漏洞利用:注意路径检查 工具： dsstoreexppython ds_store_exp.py http://www.am0s.com/.DS_Store 

## 网站压缩文件备份：

- 直接访问/遍历，典型文件类型如下：

    ```
    .rar
    .zip
    .7z
    .tar.gz
    .bak
    .swp
    .txt
    .html
    ```

## SVN 导致文件泄露：

- 漏洞利用: 工具： dvcs-ripperrip-svn.pl -v -u http://www.am0s.com/.svn/ 

## WEB-INF/web.xml 泄露

- 漏洞检测以及利用方法： 通过找到web.xml文件，推断class文件的路径，最后直接class文件，在通过反编译class文件，得到网站源码。

## CVS 泄露

- 漏洞利用: http://XXXX/CVS/Root 返回根信息