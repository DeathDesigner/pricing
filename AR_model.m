function [] = AR_model()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
file = dir('D:\pricing\month_return');
file_name = {file.name};
long = length(file_name);

arch_test = zeros(long-2);
for i = 3:long
    name = ['month_return/', file_name{i}];
    y = csvread(name, 0, 1);
    num = fix(length(y)/2);  
    arch_test(i-2) = archtest(y);
    for j = 1:min(10, num)
        model = garch(0, j);
        [EstMdl,EstParamCov,logL,info] = estimate(model, y);
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
        name = ['AR_result/', file_name{i}, '_ar', num2str(j), '.mat'];
        save(name, 'coe');
    end
end
return 
end

