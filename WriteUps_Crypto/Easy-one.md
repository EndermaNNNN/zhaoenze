# Easy_one

## 解题思路：

- 拿到题目，下载附件，打开一看，发现有四个文件，一个 `msg001` ，一个 `msg001.enc` ，一个 `msg002.enc` ，一个加密程序：

    ```C
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
    int main(int argc, char **argv)
    {
        if (argc != 3)
            {
               	printf("USAGE: %s INPUT OUTPUT\n", argv[0]);
                return 0;
            }
        FILE* input  = fopen(argv[1], "rb");    
        FILE* output = fopen(argv[2], "wb");
        if (!input || !output)
            {
                printf("Error\n");
                return 0;
            }
        char k[] = "CENSORED";  //确定密钥
        char c, p, t = 0;
        int i = 0;
        while ((p = fgetc(input)) != EOF)   //读到输入文件读完
        {
            c = (p + (k[i % strlen(k)] ^ t) + i*i) & 0xff;  //就这一句是核心，加密变换,利用密钥语句 `CENSORED` 进行类似多表代换的操作。
            t = p;  
            i++;
            fputc(c, output);   //输出
        }
            return 0;
    }
    ```

- 先想到是不是把加密程序逆过来解 `msg002` ，于是尝试修改代码,把输入输出倒换，p不是等于c+多少多少嘛，那就c=p-多少多少，t换成=c就行：

    ```C
    ...
    while ((p = fgetc(input)) != EOF)
        {
            c = (p - (k[i % strlen(k)] ^ t) - i*i) & 0xff;
            t = c;
            i++;
            fputc(c, output);
        }
    ...
    ```

- 然而执行结果为乱码，看来有问题，只好上网找大佬的wp，发现加密程序里的那个核心 `k[]` 并非本题的 `k[]` ，本题的 `k[]` 需要自己求，根据 `msg001` 和 `msg001.enc` 之间的关系来推算。

- 按照大佬的思路，重新写了一下代码，核心思想就是用 `msg001` 和 `msg001.enc` 里的每一个元素的变换密钥拼出一个字符串，这个字符串就是目标密钥串：

    ```C
    #pragma warning(disable:4996);
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
    int main(int argc, char** argv)
    {
        if (argc != 2)
        {
            printf("USAGE: %s INPUT OUTPUT\n", argv[0]);
            return 0;
        }
        FILE* input = fopen(argv[1], "rb");
        char j = 0;
        char c, p, t = 0;
        int i = 0;
        char m[] = "Hi! This is only test message\n";  //msg001中的值

        while (i<strlen(m))
        {
            p = fgetc(input);
            for (j = 0; j < 128; j++) //ASCII码全试一遍，总能找到一个对的代换
            {
                c = (p - (j ^ t) - i * i) & 0xff; //从密文算明文
                if (c == m[i])   //发现对上了，说明密钥碰对了
                {
                    i++;    //试下一位
                    printf("%c", j); //打印这一位密钥字符
                    t = c;  //换密钥
                    break;  //试下一位
                }
            }

        }
        return 0;
    }
    ```

- 得到结果密钥串为：

        VeryLongKeyYouWillNeverGuess

- 将这个结果作为加密字符串 `k[]` 写入源程序，再调换一下输入输出形成解密程序：

    ```C
    ...
    char k[] = "VeryLongKeyYouWillNeverGuess";  //换密钥串
	char c, p, t = 0;
	int i = 0;
	while ((p = fgetc(input)) != EOF) 
	{
		c = (p - (k[i % strlen(k)] ^ t) - i*i) & 0xff;  //换位
		t = c;
		i++;
		fputc(c, output);
	}
	return 0;
    }
    ```

- 运行，拿到flag！