function [] = AR_model()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
file = dir('D:\pricing\month_return');
file_name = {file.name};
long = length(file_name);

arch_test = zeros(long-2);
for i = 3:long
    result_file = dir('D:\pricing\AR_result');
    result_file_name = {result_file.name};
    Long = length(result_file_name);
    exsit = 0;
    for m = 3:Long
        if strcmpi((result_file_name{m}(1:length(result_file_name{m})-4)),(file_name{i}(1:length(file_name{i})-4)))
            exsit = 1;
            break;
        end
    end
    if exsit == 1
        continue;
    else
        new_folder = ['D:\pricing\AR_result\',(file_name{i}(1:length(file_name{i})-4))];
        mkdir(new_folder);
    end
    name = ['month_return\', file_name{i}];
    y = csvread(name, 0, 1);
    num = fix(length(y)/2);
    arch_test(i-2) = archtest(y);
    for j = 1:min(10, num)
        model = garch(0, j);
        [EstMdl,~,logL] = estimate(model, y);
        coe.arch.name = file_name{i};
        coe.arch.value = EstMdl.ARCH;
        coe.arch.fit = logL;
        coe.arch.constant = EstMdl.Constant;
        coe.arch.var = EstMdl.UnconditionalVariance;
        
        result = ar(y, j, 'ls');
        coe.ar.name = file_name{i};
        coe.ar.value = result.Report.Parameter.ParVector;
        coe.ar.fit = result.Report.Fit.FitPercent;
        coe.ar.FPE = result.Report.Fit.FPE;
        coe.ar.MSE = result.Report.Fit.MSE;
        name = ['AR_result\', file_name{i}(1:length(file_name{i})-4),'\', 'result_', num2str(j), '.mat'];
        save(name, 'coe');
    end
end
return
end

