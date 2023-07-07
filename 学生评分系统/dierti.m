clc %清除命令行输出结果
clear %清除工作区输出结果

code_file_hanshu = 'fun1.m';%获取学生的函数代码文件
code_file_mingling = 'mingling2.m';%获取学生的命令代码文件
daima_fenshu = 0;%初始化代码扣分
jieguo_fenshu = 0;%初始化结果得分
zhijie0fen = false;%初始化结果直接0分为false


for j = 1:2
    if j == 1
        code = code_file_hanshu;
    elseif j == 2
        code = code_file_mingling;
    end
    %错误检查代码段开始
    errorStruct = checkcode(code); %获取要检查的代码文件
    if ~isempty(errorStruct)
        for i = 1:length(errorStruct)
            disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
            disp(code)
            disp(['第',num2str(errorStruct(i).line),'行有问题:']);
            disp(['错误信息：',errorStruct(i).message]);
            disp(['代码质量类型：',num2str(errorStruct(i).fix)])
            disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
        end
    else
        disp([code,'没有发现代码质量问题！！']);
    end
    %错误检查代码段结束
    %代码质量评分开始
    if ~isempty(errorStruct)
        for i = 1:length(errorStruct)
            cuowuleixin = errorStruct(i).fix;%获取代码质量结果类型
            %代码错误扣1分赋值开始
            if cuowuleixin == 0
                daima_fenshu = daima_fenshu + 1;
                %代码错误扣1分赋值结束
                %代码质量低扣0.5分开始
            elseif cuowuleixin == 1
                daima_fenshu = daima_fenshu + 0.5;
            end
            %代码质量低扣0.5分结束
        end
    end
    %代码质量评分结束
end
disp(['代码质量最终扣分：', num2str(daima_fenshu)])

%代码内容检测
code_contents = fileread(code_file_hanshu);%读取函数文件内容
y_found_mingling = strfind(lower(code_contents),'y=fun1');%查找命令文件内是否有"y=fun1"
fun1_found_hanshu = strfind(lower(code_contents), 'fun1');%查找函数文件内是否有"fun1"

if ~isempty(fun1_found_hanshu) && contains(lower(code_contents(fun1_found_hanshu(1):18)), 'x')
    disp('函数代码形参设置为x')
else
    daima_fenshu = daima_fenshu + 1;
    disp('代码未设形参为x扣1分')
    if isempty(y_found_mingling)
        daima_fenshu = daima_fenshu + 1;
        disp('函数文件未定义求y')
    end
end
disp(['代码内容检测扣分：',num2str(daima_fenshu)])

%代码输出结果评分
shili_n = 3090;%实例代码的n
shili_y = 3.999879986257297;%实例代码的y
xuesheng_n = 0;%学生代码的n
xuesheng_y = 0;%学生代码的y
code_text_xuesheng = fileread(code_file_mingling);%读取学生代码放到code_text_xuesheng
try
    revoid_jieguo = evalc(code_text_xuesheng);%运行学生代码获得学生代码计算结果
    matches = regexp(revoid_jieguo, '=\s*([\d.]+)', 'tokens');
    xuesheng_y = str2double(matches{1}{1});
    xuesheng_n = str2double(matches{2}{1});
    if xuesheng_n< xuesheng_y
        ll = xuesheng_y;
        xuesheng_y = xuesheng_n;
        xuesheng_n = ll;
    end
catch
    disp('学生代码运行错误')
    xuesheng_n = 66 ;
    xuesheng_y = 0.9184;
end
n_k = abs(xuesheng_n - shili_n);
y_k = abs(xuesheng_y - shili_y);
if n_k == 0
    jieguo_fenshu = jieguo_fenshu + 5;
else
    if n_k <100
        jieguo_fenshu = jieguo_fenshu + 3;
    else
        jieguo_fenshu =jieguo_fenshu+ 2;
    end

end
if y_k == 0
    jieguo_fenshu = jieguo_fenshu+5;
else
    if y_k <0.8
        jieguo_fenshu = jieguo_fenshu+3;
    else
        jieguo_fenshu = jieguo_fenshu+2;
    end

end

%权重计算
disp(['代码计算结果得分：',num2str(jieguo_fenshu)])
daimazhiliang_defeng = 10 ;
zongfen = (daimazhiliang_defeng - daima_fenshu)*0.4 + jieguo_fenshu*0.7;
disp(['进行权重计算后，学生最终得分：',num2str(zongfen)])





