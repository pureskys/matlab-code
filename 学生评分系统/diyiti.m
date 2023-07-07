%~~~~~~~~~~~~~~~~~~~~~~~~
%示例代码的y变量需要改为y1
%~~~~~~~~~~~~~~~~~~~~~~~~~
clc %清除命令行输出结果
clear %清除工作区输出结果

code_file = 'mingling1.m';%获取学生的代码文件
daima_fenshu = 0;%初始化代码扣分
jieguo_fenshu = 0;%初始化结果扣分
zhijie0fen = false;%初始化结果直接0分为false


errorStruct = checkcode(code_file); %获取要检查的代码文件
%错误检查代码段开始
if ~isempty(errorStruct)
    for i = 1:length(errorStruct)
        disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
        disp(['第',num2str(errorStruct(i).line),'行有问题:']);
        disp(['错误信息：',errorStruct(i).message]);
        disp(['代码质量类型：',num2str(errorStruct(i).fix)])
        disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    end
else
    disp('没有发现代码质量问题！！');
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
    disp(['代码质量最终扣分：', num2str(daima_fenshu)])
end
%代码质量评分结束


%代码内容检测
code_contents = fileread(code_file);%读取文件内容
inputs_found = strfind(lower(code_contents), 'input');%查找文件内是否有"input"
disps_found = strfind(lower(code_contents),'disp');%查找文件内是否有"disp"
if ~isempty(inputs_found) && contains(lower(code_contents(inputs_found(1):end)), '请输入x的值:')
    disp('代码使用了 "input" 函数，并且其提示信息为 "请输入x的值:"')
elseif ~isempty(inputs_found) && ~contains(lower(code_contents(inputs_found(1):end)), '请输入x的值:')
    daima_fenshu = daima_fenshu + 1;
    disp('代码了使用 "input" 函数，但是其提示信息不为 "请输入x的值:"')
end
if ~isempty(disps_found)
    if strfind(lower(code_contents(disps_found(1):end)),'y') == 6
        disp('代码使用了 "disp" 函数，并且无其它字符输出')
    elseif strfind(lower(code_contents(disps_found(1):end)),'y') ~= 6
        disp('代码使用了 "disp" 函数，但有其它字符输出')
        daima_fenshu = daima_fenshu + 1;
    end
end
if isempty(inputs_found) && isempty(disps_found)
    disp('没有使用"disp"和"input"')
    daima_fenshu = daima_fenshu + 2.5;
elseif isempty(inputs_found) && ~isempty(disps_found)
    disp('没有使用"input"')
    daima_fenshu = daima_fenshu + 2;
elseif ~isempty(inputs_found) && isempty(disps_found)
    disp('没有使用"disp"')
    daima_fenshu = daima_fenshu + 1;
end
disp(['代码内容检测后扣分：',num2str(daima_fenshu)])
disp('评分中，请稍后.....')


%代码输出结果评分
y = 'lala';
list_x = -1000:1000;
list_jieguo1 = [];
list_shilidaima = [];
for x = list_x
    code_text_xuesheng = fileread(code_file);%读取学生代码放到code_text
    code_text_shilidaima = fileread("shilidaima_1.m");%读取实例代码

    code_text_xuesheng_fix = regexprep(code_text_xuesheng,'input\(.*?\)',num2str(x));%对学生代码进行修改
    code_text_xuesheng_fix1 = regexprep(code_text_xuesheng_fix,'else(.*)','else$1');%对学生代码进行修改
    code_text_xuesheng_fix2 = regexprep(code_text_xuesheng_fix1,'clear,clc','');%对学生代码进行修改

    code_text_shilidaima_fix = regexprep(code_text_shilidaima,'input\(.*?\)',num2str(x));%对实例代码进行修改

    revoid_jieguo = evalc(code_text_xuesheng_fix2);%运行学生代码获得学生代码计算结果
    revoid_shilidaima = evalc(code_text_shilidaima_fix);%运行实例代码获得学生代码计算结果
    if ~strcmp(y,'lala')

        % disp(['学生代码运行结果0：',num2str(x),'~~~~',num2str(y)])
        revoid_jieguo = y;

        y = 'lala';
    else
        % disp(['学生代码运行结果：',num2str(x),'~~~~',num2str(revoid_jieguo)])

    end
    %disp(['实例代码返回结果：', num2str(x),'~~~~',num2str(revoid_shilidaima)])
    list_shilidaima(end + 1) = str2double(revoid_shilidaima);
    if isnumeric(revoid_jieguo)
        list_jieguo1(end + 1) = revoid_jieguo;%将学生代码返回的结果储存到list
    elseif  ischar(revoid_jieguo)
        list_jieguo1(end+1) = str2double(revoid_jieguo);%将实例代码返回的结果储存到list
    end
end
for i = 1:list_shilidaima

    if i <=2000
        if isnan(list_jieguo1(i))
            continue
        else
            k = abs(list_jieguo1(i) - list_shilidaima(i));
            if k <= 30 %结果得分区间
                jieguo_fenshu = jieguo_fenshu +0.5;%代码计算结果加分区域
            end

        end
    end

end
disp(['代码计算结果得分：',num2str(jieguo_fenshu)])
daimazhiliang_defeng = 10 ;
zongfen = (daimazhiliang_defeng - daima_fenshu)*0.5 + jieguo_fenshu*0.5;
disp(['进行权重计算后，学生最终得分：',num2str(zongfen)])








