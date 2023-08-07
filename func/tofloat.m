function [out,revertclass] = tofloat(in)
    %TOFLOAT Convert image to floating point
    %   [OUT REVERTCLASS] = TOFLOAT(IN) converts the input image IN to
    %   floating-point. if IN is a double or single image,then OUT 
    %   equals IN. Otherwise, OUT equals IM2SINGLE(IN). REVERTCLASS is
    %   a function handle that can be used to convert back to the class
    %   of IN.

    identity = @(x) x;
    tosingle = @im2single;
    
    table = {'uint8', tosingle, @im2unit8
        'uint16', tosingle ,@im2unit16
        'int16', tosingle, @im2int16
        'logical', tosingle, @logical
        'double', identity, identity
        'single', identity, identity};
    
    classIndex = find(strcmp(class(in), table(:,1)));
    
    if isempty(classIndex)
       error('Unsupported input image class.');
    end
    
    out = table{classIndex, 2}(in);
    
    %revertclass是一个函数句柄，用于把输出转换为与f相同的类
    revertclass = table{classIndex, 3};