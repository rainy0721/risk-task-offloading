clear;clc;
% 定义数据
cases = struct('users', 'hetero');
numVehicles = 4;%车辆数量
% Ns =50;%用户数量
Ns = 50;%用户数量
numBS = 2;%BS数量
an_s = 0.2;
%ans = linspace(0.1, 1, 10);
kns =1.2;
%kns = linspace(0.2, 2, 10);
%an = 0.2 * ones(user_num, 1);%用户的前景理论参数
%kn = 1.2 * ones(user_num, 1);%用户的前景理论参数

%% Stackelberg methods
% Assuming 'case', 'Ns', 'ans', 'kns', 'cpars', 'main', and 'params' are defined

% Assuming Ns, ans, kns, and cpars are defined before this loop

for N = Ns
    % Set random parameter in order to generate the same parameters
    disp('Generating new parameters');
    rng('shuffle'); % Seed random number generator with current time
    params = set_parameters(cases, N);

    fprintf('Number of users: %d\n',N);

    for an = an_s
        params.an = an * ones(N,numVehicles + numBS);
        disp(['Sensitivity an: ' num2str(params.an(1))]);

        for kn = kns
            params.kn = kn * ones(N,numVehicles + numBS);
            disp(['Sensitivity kn: ' num2str(params.kn(1))]);
                % if bpars is -1 we don't want constant offloading
                if params.CONSTANT_OFFLOADING
                    bpars = [-1, 0, 0.5, 1];
                else
                    bpars = (-1);
                end
                
                while ~isempty(bpars)  % 当bpars不为空时执行循环
                    
                    bpar = bpars(end);  % 获取最后一个元素
                    bpars(end) = [];    % 移除最后一个元素
                    params.bpar = bpar;  % 将元素赋值给params.bpar

                    % if bpar is -1 then we don't want constant offloading
                    if bpar == -1
                        params.CONSTANT_OFFLOADING = false;
                        params.bpar = 0;
                    end

                    for repetition = 1
                        disp(['Repetition now: ' num2str(repetition)]);

                        results = struct();

                        tic;

                        % Run main simulation

                        results = mecoffloading(params);
                        

                        running_time = toc;
                        disp('Time of simulation:');
                        disp(running_time);

                        results.N = N;
                        results.time = running_time;
                        results.repetition = repetition;
                        
                        outfile = strcat('saved_runs/results/individual/', cases.users,  ...
                            '_N_', num2str(N), '_an_', num2str(round(an, 3)), ...
                            '_kn_', num2str(round(kn, 3)),  '_', num2str(repetition),'.mat');

                        % 将结果保存到文件中
                        save(outfile, 'results', '-mat');


                    end
                end
            
        end
    end
end

