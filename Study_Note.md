# Burp Suite

## 一个理解误区：Intercept的含义

- intercept是拦截，这意味着如果用户在配置好Burp Suite之后，通过代理服务器发送的任何请求都会被Burp Suite所截获，并且 **不会转发出去** ，除非 **用户自己点击Send** 。

- 所以当打开Burp Suite后，刷新网页永远不会得到新的内容，因为所有的新请求都被Burp Suite拦下了————这不是断网，这只是请求被拦截而已。

- 不要觉得自己的网络有问题，Burp Suite仍在正常工作。