%低通过滤器，取D0为填充图像宽度的0.05
f=imread('1.jpeg');
[f,revertclass]=tofloat(f);
PQ=paddedsize(size(f));
[U,V]=dftuv(PQ(1),PQ(2));
D=hypot(U,V);
D0=0.05*PQ(2);
F=fft2(f,PQ(1),PQ(2));
H=exp(-(D.^2)/(2*(D0^2)));
g=dftfilt(f,H);
g=revertclass(g);
imshow(g)