function g=intrans(f,method,varargin)
    %intrans执行强度（灰度）变换
    %G=intrans(F,'neg')计算输入图像F的负片图像
    
    %G=intrans(F,'log',C,Class)计算C*log(1+F)并且将结果乘以正常数C
    %如果省略了最后两个参数，C默认为1.因为log函数被频繁地用于显示傅里叶光谱
    %Class参数提供了指定输出的类为‘uint8’和'uint16'的选项。
    %如果省略参数类，输出与输入属于同一类
    
    %G=intrans(F,'gamma',GAM)使用参数GAM(一个必须的输入)对输入图像执行gamma变换
    
    %G=intrans(F,'stretch',M,E)使用表达式1./(1+(M./F).^E)计算对比度拉伸变换
    %M的范围必须在[0,1]之间，M的默认值是mean2(tofloat(F)),E的默认值是4.
    
    %G=intrans(F,'specified',TXFUN)
    %执行强度变化s=TXFUN(r)(r是输入强度，s是输出强度)
    %TXFUN是一个强度变换（映射）函数,结果为一个在[0,1]内取值的向量
    %参数TXFUN至少有两个值
    
    %对于'neg','gamma','stretch' 和 'specified'变换，
    %对于数值在[0,1]范围之外的浮点输入图像，首先使用MAT2GRAY进行缩放。
    %其他图像使用tofloat转换为浮点数
    
    %输出设输入是同一类，除非'log'选项指定了不同的类
    
    %验证正确的输入数量
    error(nargchk(2,4,nargin))
    
    if strcmp(method,'log')%比较两个字符串，相等时返回TRUE，不相等返回FALSE
        %对数变换处理图像类不同于其他变换，让logTransform函数处理后返回
        g=logTransform(f,varargin{:});
        return;
    end
    
    %如果f是浮点数，检查其是否在[0,1]范围内，如果不是，强制它使用mat2gray函数
    if isfloat(f) && (max(f(:))>1 || min(f(:))<0)
        f=mat2gray(f);
    end
    [f,revertclass]=tofloat(f);%存储f的类以备后用
    %执行指定的强度变换
    switch method
        case 'neg'
            g=imcomplement(f);
        case 'gamma'
            g=gammaTransform(f,varargin{:});
        case 'stretch'
            g=stretchTransform(f,varargin{:});
        case 'specified'
            g=spcfiedTransform(f,varargin{:});
        otherwise
            error('Unkonw enhancement method.')
    end
    %转换为输入图像的类
    g=revertclass(g);
    end
    
    function g= gammaTransform(f,gamma)
    g=imadjust(f,[],[],gamma);
    end
    
    function g=stretchTransform(f,varargin)
    if isempty(varargin)%如果空返回true
        %使用默认值
        m=mean2(f);%mean2(tofloat(f))，f在进入函数之前用tofloat处理过，所以省略
        E=4.0;
    elseif length(varargin)==2
        m=varargin{1};
        E=varargin{2};
    else
        error('Incorrect number of inputs for stretch method.')
    end
    g=1./(1+(m./f).^E);
    end
    
    function g=spcfiedTransform(f,txfun)%指定任意灰度变化
    %txfun是任意定义的灰度变化函数，其包含该变换函数的值，例如txfun(1)对应着原图像灰度为0变换后的值
    %用[0,1]范围的浮点数表示输入和输出图像，会大大简化程序，故输入的txfun应提前处理至[0,1]范围内
    %f是在[0,1]范围内的浮点数
    txfun=txfun(:);%强制转换为列向量
    if any(txfun) <= 0
        error('All elements of txfun must be in the range [0 1].')
    end
    T=txfun;
    X=linspace(0,1,numel(T))';
    g=interp1(X,T,f);
    end
    
    function g=logTransform(f,varargin)
    [f,revertclass]=tofloat(f);%将f转换为单精度或双精度图像
    if numel(varargin)>=2%numel(A)返回A的元素个数
        if strcmp(varargin{2},'uint8')
            revertclass=@im2uint8;
        elseif strcmp(varargin{2},'uint16')
            revertclass=@im2uint16;
        else
            error('Unsupported CLASS option for "log" method.')
        end
    end
    if numel(varargin)<1
        %取C的默认值
        C=1;
    else
        C=varargin{1};
    end
    g=C*(log(1+f));
    g=revertclass(g);
    end
    