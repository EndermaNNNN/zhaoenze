# Linux系统与网络管理

## 第四章：shell脚本编程基础

- 第一句程序：

    - ```#!/usr/bin/env bash```

        ```echo "hello world"```

        第一句的意思是：运行的解释器为 **环境变量表中存储的bash** ，系统会自动在 **env** 设置中查找bash的安装路径，这样无论bash安到了哪里，只要在环境变量里设置过，就可以执行。

        若不用环境变量设置的bash，而要用某一特定安装目录（假设为/usr/bin文件夹下）的其它版本的bash，则命令应为 ```#!/usr/bin bash``` ,即拿掉/env。

        同理，同为解释型语言的python在编写脚本时也可以写为 ```#!/usr/bin/env python```

    - ```ps | grep $$```

        这一句是查看当前默认解释器；系统会响应如下语句：

        ```3537 pts/2    00:00:00 bash```

        表示当前我打开的第三个终端（之前被关掉的终端也算，终端号从pts/0开始）使用的默认解释器是bash。

    - ```type bash```

        查看当前解释器的绝对路径

    - ```bash --version```

        查看当前解释器的版本号

- 变量

    - 语法规则：

        变量名区分大小写

        =左右两边不能有空格

        单引号包围的字符串中不对特殊符号做解释执行

        双引号包围的字符串中对特殊符号解释执行

        使用 \ 转义特殊符号避免被解释执行

    - 例句：

        - ```PRICE_PER_APPLE=5```

            ```echo $PRICE_PER_APPLE```

            ```echo "The price of an Apple today is: \$HK $PRICE_PER_APPLE"```

            上述三句完成了“定义变量”和“输出变量”的操作，需要注意的是第三句中 “$HK” 的$是经过转义的。

        - ```echo $greeting" now with spaces: $greeting"```

            ```echo $greeting" now with spaces:" $greeting```

            这两句均完成了字符串拼接操作，但区别在于：前一句因为变量在双引号内，故保留了变量内的多余空格；后一句因为变量不在双引号内，故系统会将所有多余的空格删掉，只剩一个。

        - ```bash -x <script.sh>```

            以调试模式运行“script.sh”这一脚本。

        - 传参

            ```echo $3```

            输出参数数组中的第三个参数

            $0 指代脚本文件本身

            $1 指代命令行上的第1个参数

            $2 指代命令行上的第2个参数，以此类推其他参数的脚本内引用方法

            $@ 指代命令行上的所有参数（参数数组）

            $# 指代命令行上的参数个数（参数数组大小）

        - 数组

            Bash 4.0 开始支持关联数组

            declare -a 声明的是「索引」数组，declare -A 声明的是「关联」数组。
            
            如果同时使用 -a -A ，-A 优先级更高，数组被声明为「关联」数组

            Bash 4.2 开始支持 declare -g 方式声明关联数组为「全局」变量，在此之前，关联数组仅限局部变量作用域

            ```echo ${#my_array[@]}```

            以上代码指输出my_array数组的元素个数（注意 **#** 不要丢）

        - 关联数组理解：

            关联数组的本质其实就是 **键值对** ，数组的下标不是数字而是字符串，如 ```associative_arr['hello']='world'```

        - 关联数组的遍历：

            ```for key in "${!associative_arr[@]}";do```

            ```echo "$key ${associative_arr[$key]}"```

            需要注意的是此处 ```"${!associative_arr[@]}"``` 中的“!” **并非取反操作** ，而是 **取数组下标** 操作。

        - 代码填空：

            ```NUMBERS=(1 2 3 4 5 6 7 8 9 10)```  # 构造包含1到10整数的数组

            ```STRINGS=('hello' 'world')```  # 构造分别包含hello和world字符串的数组

            ```NumberOfNames=${#NAMES[@]}``` # 请使用动态计算数组元素个数的方法

            ```second_name=${NAMES[1]}```  # 读取NAMES数组的第2个元素值进行赋值