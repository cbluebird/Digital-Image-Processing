# DFT滤波的几个步骤

1. 使用tofloat把输入图像转换微浮点图像
```matlab
[f,revertclass]=tofloat(f)
```

2. 使用函数paddedsize获得填充参数
函数可以返回一个向量PQ，PQ(1),PQ(2)就是满足填充要求的长和宽
```matlab
PQ=paddedzsize(size(f))
```

3. 得到有填充图像的傅里叶变换
```matlab
F=fft(f,PQ(1),PQ(2))
```

4. 生成一个滤波器函数，方式有很多种，在每个文件中详细讨论

5. 用滤波器乘以该变换
```matlab
G=H.*F
```

6. 获得G的IFFT
```matlab
g=ifft2(G)
```

7. 将左上部的矩形裁剪为原始大小
```
g=g(1:size(f,1),1:size(f,2))
```

8. 将滤波后的函数转换为图像

```
g=revertclass(g)
```