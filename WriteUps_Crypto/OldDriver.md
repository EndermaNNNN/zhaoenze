# OldDriver

## 解题思路：

- 没看明白，代码在这儿但是我却不会用...：

    ```python
    # -*- coding:utf8 -*-
    import gmpy2   
    import json, binascii   
    from functools import reduce

    def chinese_remainder(n, a):   
        sum = 0
        prod = reduce(lambda a, b: a*b, n)
        for n_i, a_i in zip(n, a):
            p = prod // n_i
            sum += a_i * modinv(p, n_i) * p 
        return int(sum % prod)  
    def modinv(a, m): return int(gmpy2.invert(gmpy2.mpz(a), gmpy2.mpz(m)))   #求 a 和 m 的乘法逆元

    with open("mayday.json") as dfile: 
        data = json.loads(dfile.read())  
    data = {k:[d.get(k) for d in data] for k in {k for d in data for k in d}}   
    t_to_e = chinese_remainder(data['n'], data['c'])   
    t = int(gmpy2.mpz(t_to_e).root(10)[0])  
    print(binascii.unhexlify(hex(t)[2:-1]))  
    ```

    大概意思是先用孙子定理解同余方程组，推出原先的 t^e ,然后解 t^e 的 e 次方根，推回原本的t，但是具体步骤还不是很懂，明天仔细看一下。