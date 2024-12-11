clear;clc;
% ��������
cases = struct('users', 'hetero');
numVehicles = 4;%��������
Ns =50;%�û�����
%Ns = [1, 2, 5, 10, 25, 50, 75, 100];%�û�����
numBS = 2;%BS����
ans = 0.2;
%ans = linspace(0.1, 1, 10);
kns = 1.2;
%kns = linspace(0.2, 2, 10);
%an = 0.2 * ones(user_num, 1);%�û���ǰ�����۲���
%kn = 1.2 * ones(user_num, 1);%�û���ǰ�����۲���

%% Stackelberg methods
% Assuming 'case', 'Ns', 'ans', 'kns', 'cpars', 'main', and 'params' are defined

% Assuming Ns, ans, kns, and cpars are defined before this loop

for N = Ns
    % Set random parameter in order to generate the same parameters
    disp('Generating new parameters');
    rng('shuffle'); % Seed random number generator with current time
    params = set_parameters(cases, N);

    fprintf('Number of users: %d\n',N);

    for an = ans
        params.an = an * ones(N,numVehicles + numBS);
        disp(['Sensitivity an: ' num2str(params.an(1))]);

        for kn = kns
            params.kn = kn * ones(N,numVehicles + numBS);
            disp(['Sensitivity kn: ' num2str(params.kn(1))]);
                % if bpars is -1 we don't want constant offloading
                if params.CONSTANT_OFFLOADING
                    bpars = [-1, 0, 0.5, 1];
                else
                    bpars = [-1];
                end
                
                while ~isempty(bpars)  % ��bpars��Ϊ��ʱִ��ѭ��
                    
                    bpar = bpars(end);  % ��ȡ���һ��Ԫ��
                    bpars(end) = [];    % �Ƴ����һ��Ԫ��
                    params.bpar = bpar;  % ��Ԫ�ظ�ֵ��params.bpar

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
                        results = Svehicle(params);
                        
                        % check_all_parameters(params);
                        % check_best_parameters(params);

                        running_time = toc;
                        disp('Time of simulation:');
                        disp(running_time);

                        results.N = N;
                        results.time = running_time;
                        results.repetition = repetition;

                        if params.SAVE_RESULTS
                            if params.CONSTANT_OFFLOADING
                                constant_str = ['_b_constant_' num2str(round(bpar, 3))];
                            else
                                constant_str = '';
                            end

                            % Ensure directory exists
              
                            output_dir = 'saved_runs/results/individual/';
                            if ~exist(output_dir, 'dir')
                                mkdir(output_dir);
                            end

                            % Create file path
                           % outfile = [output_dir cases.users constant_str '_N_' num2str(N) ...
                            %    '_an_' num2str(round(an, 3)) '_kn_' num2str(round(kn, 3)) ...
                             %   '_c_' num2str(round(cpar, 3)) '_' num2str(repetition)];

                           % save(outfile, 'results');
                        end
                    end
                end
            
        end
    end
end

