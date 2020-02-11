# Web2

## 解题思路：

- 打开网页，直接一段php代码，该干啥全都给说得清清楚楚：

    ```php
    <?php 
    $miwen="a1zLbgQsCESEIqRLwuQAyMwLyq2L5VwBxqGA3RQAyumZ0tmMvSGM2ZwB4tws"; 

    function encode($str){ 
        $_o=strrev($str); 
        // echo $_o; 
            
        for($_0=0;$_0<strlen($_o);$_0++){ 
            
            $_c=substr($_o,$_0,1); 
            $__=ord($_c)+1; 
            $_c=chr($__); 
            $_=$_.$_c;    
        }  
        return str_rot13(strrev(base64_encode($_))); 
    } 

    highlight_file(__FILE__); 
    /* 
    逆向加密算法，解密$miwen就是flag 
    */ 
    ?> 
    ```

    它的逻辑很简单：先把明文翻转，再把每一个明文对应的ASCII值加一，然后进行base64编码，最后再反转回来，每个字母往前移动十三位。

- 目的很明确，把这个加密算法逆向出来就行了：

    ```php
    <?php
    header('Content-Type:textml;charset=utf-8');
    $miwen="a1zLbgQsCESEIqRLwuQAyMwLyq2L5VwBxqGA3RQAyumZ0tmMvSGM2ZwB4tws";
    $miwen=str_rot13($miwen);
    $_o=base64_decode(strrev($miwen));
    $_ ='';
    for($_0=0;$_0<strlen($_o);$_0++){

        $_c=substr($_o,$_0,1);
        $__=ord($_c)-1;
        $_c=chr($__);
        $_=$_.$_c;
    }
    $_=strrev($_);
    #echo $miwen."\n";
    #echo strrev($miwen)."\n";
    echo $_."\n";
    ?>
    ```

- 逻辑很简单，解出源字符串即可，这里有个东西需要注意： `str_rot13` 不能丢，而且它的逆向其实就是它自己，字母表一共26位，再调一遍不就又回到原来了嘛！