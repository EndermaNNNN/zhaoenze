# flag in your hand

## 解题思路：

- 首先拿到题，下载附件，发现有一个html和一个js，打开html看看，发现有一个输入框，让我们输入密码，先随便输入一个，网页回复：

    `Wrong!`

- 审查元素，看到整个网页的运作机理：

    ```javascript
    
			var ic = false;
			var fg = "";

			function getFlag() {
				var token = document.getElementById("secToken").value;
				ic = checkToken(token);
				fg = bm(token);
				showFlag()
			}

			function showFlag() {
				var t = document.getElementById("flagTitle");
				var f = document.getElementById("flag");
				t.innerText = !!ic ? "You got the flag below!!" : "Wrong!";
				t.className = !!ic ? "rightflag" : "wrongflag";
				f.innerText = fg;
			}
	```

- 再往下看，输入框的属性名： `secToken` ,知道了，是要往里传参，打开js文件直接搜这个 `checkToken` ，看到源码：

    ```javascript
    function checkToken(s) {
    return s === "FAKE-TOKEN";
    }
    ```

- 看到这个 `fake-token` 就感觉不靠谱，往框里填一下，果然不对，再仔细看代码，这个 `ic` 是否在其他函数里变过？顺着找 `bm()` ：

    ```javascript
    function bm(s) {
    return rb(rstr(str2rstr_utf8(s)));
    }
    
    ... #一通疯狂加密，但是都没有涉及 `ic` 的操作，直到：

    function ck(s) {
    try {
        ic
    } catch (e) {
        return;
    }
    var a = [118, 104, 102, 120, 117, 108, 119, 124, 48,123,101,120];
    if (s.length == a.length) {
        for (i = 0; i < s.length; i++) {
            if (a[i] - s.charCodeAt(i) != 3)
                return ic = false;
        }
        return ic = true;
    }
    return ic = false;
    }
    ```

- 看到这儿明白了，这个函数明面上是加密我们输入的值，实际上是在拿我们输入的值跟数组 `a` 进行对照， 如果 `chr(int(a-3))==chr(int(s))`，就判断我们正确。

- 这里确实惊讶了一下，在js文件函数里写的参数 `ic` 居然能影响到网页脚本上的参数 `ic` 的值，很神奇，但仔细想一想，它俩就是一个东西，function函数拿到全局变量的值也很合理嘛。

- 按照它的写一个解密函数：

    ```python
    s = [118, 104, 102, 120, 117, 108, 119, 124, 48,123,101,120]
    ans = ''
    for i in s:
        ans += chr(int(i-3))
        print(ans)
    ```

- 拿到结果：security-xbu，把它填入框里，拿到flag。

- 这里其实引出了一个更好的方法，直接在js脚本里搜 `ic` 就能拿到东西了呀。