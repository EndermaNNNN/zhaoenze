# NaN_Batman

## 解题思路：

- 打开网页，下载他给的附件，附件名称叫 `web100` ， 无后缀，用记事本打开，发现里面是一段JS代码，本来完全没头绪，上网搜索后明白应该用 **浏览器** 打开它。

- 用浏览器打开，发现里面很多口，乱码，想办法解决乱码问题，有人说直接alert()就行，但是为什么呢？

    我在网上找了半天，很多人说是编码问题，于是我尝试在 `web100` 的script标签里加编码方式 `charset=gb2312` , `charset=utf-8` 均无效，搞不明白为什么alert就行。

    提交之后又看了一下别人的writeup，明白了，原来那些乱码都是类似`<0x0f>`的ASCII码，他们用编辑器打开可以看到，但我没用编辑器，所以用VS Code看到的就是一个一个的“口”。这些函数应该被 `eval` 读取并直接运行的（eval确实可以直接执行标签中的JS语句），但由于编码格式，这些ASCII码在被 `eval` 函数执行的同时，仍然无法被识别（虽然这一段代码确实被执行了），`eval` 可以自动识别ASCII，但浏览器的控制台不可以。

    既然不能用 `eval` 执行，那就用浏览器能识别的方法显示，用 `alert` 或者 `console.log` 均可。

- 靠alert成功显示乱码，发现是一段代码：

    ```javascript
        var e=document.getElementById("c").value;
        if(e.length==16)if(e.match(/^be0f23/)!=null)
        if(e.match(/233ac/)!=null)
        if(e.match(/e98aa$/)!=null)
        if(e.match(/c7be9/)!=null){
            var t=["fl","s_a","i","e}"];
            var n=["a","_h0l","n"];
            var r=["g{","e","_0"];
            var i=["it'","_","n"];
            var s=[t,n,r,i];
            for(var o=0;o<13;++o){
                document.write(s[o%4][0]);s[o%4].splice(0,1)}}}
                document.write('<input id="c"><button onclick=$()>Ok</button>');
                delete _
    ```
- 首先要前面四个if都满足才能进行下一步，`match` 就是说e里面有这个元素，那么就找一个16个字长的e，里面含有这些元素即可：```be0f233ac7be98aa``` ，这个e其实就是一个flag，但我是真的想不到……

- 现在进行下一步：运行里面的循环，这个本来我是准备自己手算的，但有高手告诉了我：可以直接粘到网页控制台去跑，那敢情好，于是粘完跑出结果：`flag{it's_a_h0le_in_0ne}`。

## 学到的知识：

- 看到`<script>`第一反应应该是“这是个js脚本，尝试用浏览器打开”。

- `eval` 函数的作用是：计算传给它的参数，并执行其中的的 JavaScript 代码。

    `alert` 函数的作用是：将传给它的参数以警告弹窗的形式打印出来。

- 拿到JS脚本之后可以直接在浏览器控制台里跑，而不需要自己吭哧吭哧算。