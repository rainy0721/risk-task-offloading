function params = set_parameters(cases, N)
    % Sets the parameters used in the simulation

    % Parameters
    SAVE_FIGS = true;
    ONE_FIGURE = false;
    GENERATE_FIGURES = true;
    GENERATE_CONVERGING_FIGURES = true;
    LOAD_SAVED_PARAMETERS = false;
    SAVE_PARAMETERS = false;
    SAVE_RESULTS = true;

    CONSTANT_OFFLOADING = false;

    e1 = 30;

    
    if strcmp(cases.users, 'hetero')
       % Initialization
        Dj= (1e3 + rand(N, 1) * 1e3);%每个用户j的任务的数据大小（bite为单位）,对应论文里的Dj
       % Dj = [1242.31495021018;1857.75816046315;1763.89381104995;1968.53184840599;1436.86645378554;1603.82074230896;1884.59197183116;1699.30115351215;1861.26007676388;1055.97427055178;1323.20132358073;1395.06075938720;1073.35770246006;1804.79153730384;1907.25743319761;1396.87690140446;1183.28466063183;1605.55926111290;1186.76275592469;1151.49090520767;1025.45386024281;1543.69068429716;1817.47445352661;1831.63646926420;1638.12693019918;1514.28758126352;1645.93974484607;1857.20446000121;1183.84370888185;1150.31942232752;1582.38905531957;1079.94208402771;1200.48764729556;1073.99825896192;1543.25598825225;1200.29321969444;1335.36695610496;1509.55471065611;1855.90379622386;1309.57326212512;1334.15486367814;1096.22356016141;1994.64511170243;1776.35331130250;1536.27177684975;1037.21351859528;1821.89786845210;1778.59212882420;1084.44779859702;1682.49780570185];
       % Dj= [5818;5189;5736;5336;5670;5704;5658;5650;5433;5789;5045;5221;5435;5288;5335;5322;5228;5202;5145;5106;5852;5629;5518;5201;5658;5362;5741;5884;5380;5774;5761;5711;5885;5288;5948;5592;5341;5666;5279;5797;5054;5259;5210;5787;5828;5473;5143;5301;5354;5824];
          

        cj = 1e3 * ones( N, 1);
        %dn = (8e9 + rand(1, N) * 2e9) ;
        %fj = 5e8 * ones( N, 1) + rand( N, 1) * 5e8;%每个用户j的计算能力，当任务卸载失败的时候，迫不得已在本地进行计算
        fj = 4e4 * ones( N, 1);
        %fn = 6e9 * ones(1, N) + rand(1, N) * 1e9;
        T_j_tol = 0.5 * ones( N, 1) ;% + rand( N, 1) * 0.4;%每个用户j的任务完成最大容忍延迟 单位为s
        E_j_tol = 0.5 * ones( N, 1); %+ rand( N, 1) * 0.4;%每个用户j的任务完成最大容忍能耗（等计算出来真实结果，再修改）
        E_i = 3;
        E_i_current(1,1) = (0.6 + (1 - 0.6) * 1) * E_i;
        E_i_current(2,1) = (0.6 + (1 - 0.6) * 1) * E_i;
        E_i_current(3,1) = (0.6 + (1 - 0.6) * 1) * E_i;
        E_i_current(4,1) = (0.6 + (1 - 0.6) * 1) * E_i;
%            E_i_current(5) = (0.6 + (1 - 0.6) * 4) * E_i;
%             E_i_current(6) = (0.6 + (1 - 0.6) * 4) * E_i;
%              E_i_current(7) = (0.6 + (1 - 0.6) * 1) * E_i;
%               E_i_current(8) = (0.6 + (1 - 0.6) * 4) * E_i;
%                E_i_current(9) = (0.6 + (1 - 0.6) * 4) * E_i;
%                 E_i_current(10) = (0.6 + (1 - 0.6) * 4) * E_i;
        E_i_p = E_i_current - 0.1 * E_i;
        f_j_R = 4e6; 
         F_j_V= 4e10 * ones( 4, 1);
%         F_j_V(1) = 4e10 + 1 * 1e10;
%          F_j_V(2) = 4e10 + 1 * 1e7;
%           F_j_V(3) = 4e10 + 1 * 1e8;
%            F_j_V(4) = 4e10 + 1 * 1e9;
        an = 0.2 ;
        kn = 1.2 ;
        
    elseif strcmp(cases.users, 'homo')
        Dj = 1e2 * ones( N, 1);%每个用户j的任务的数据大小（bite为单位）,对应论文里的Dj 单位KB
        cj = 1.5e0 * ones( N, 1);%每个用户j处理单位bite所需要的CPU周期(Megacycles/KB)
        T_j_tol = 0.8 * ones( N, 1);%每个用户j的任务完成最大容忍延迟 单位为s
        E_j_tol = 0.8 * ones( N, 1);
        E_i = 3;
        E_i_current = (0.6 + (1 - 0.6) * rand(1, 10)) * E_i;
        E_i_p = E_i_current - 0.1 * E_i;
        fj = 7.5e2 * ones( N, 1);
        f_j_R = 3e4; 
        F_j_V = 1e3 * ones( 10, 1) + rand( 10, 1) * 1.5e3;
        an = 0.4 * ones(1, N);
        kn = 1.2 * ones(1, N);
    end
   

    % Create a structure to hold the parameters
    params = struct('SAVE_FIGS', SAVE_FIGS, 'ONE_FIGURE', ONE_FIGURE, ...
        'GENERATE_FIGURES', GENERATE_FIGURES, 'GENERATE_CONVERGING_FIGURES', GENERATE_CONVERGING_FIGURES, ...
        'LOAD_SAVED_PARAMETERS', LOAD_SAVED_PARAMETERS, 'SAVE_PARAMETERS', SAVE_PARAMETERS, 'SAVE_RESULTS', SAVE_RESULTS, ...
        'CONSTANT_OFFLOADING', CONSTANT_OFFLOADING, 'e1', e1, ...
        'Dj', Dj, 'cj', cj, 'fj', fj, 'T_j_tol', T_j_tol, 'E_j_tol', E_j_tol, 'f_j_R', f_j_R, ...
        'F_j_V',  F_j_V, 'an',  an, 'kn', kn,  ...
        'N', N,'E_i_p',E_i_p);

    % Save parameters to a file if needed
    if SAVE_PARAMETERS
        save_parameters(params);
    end
end





