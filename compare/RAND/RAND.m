% simulation.m
function results = RAND(params)
    numVehicles = 4;%车辆数量   
    Ns = 50;%用户数量   
    %Ns = [1, 2, 5, 10, 25, 50, 75, 100];%用户数量
    numBS = 2;%BS数量
    bandwidth = 5e6;%带宽
    transmissionPower_dBm = 30;%用户传输功率
    noisePower_dBm = -114;
    R = 5;%车辆与用户的覆盖范围
    v = 2;%车辆的速度
    power = 10^(transmissionPower_dBm/10) / 1000; % 转换为瓦特
    noise = 10^(noisePower_dBm/10) / 1000;
     % Initialize b 
    [b,b1] = initialize(numBS,numVehicles,params.Dj);
    expected_utility = zeros(Ns,1);
    users = [1.44937738980625,2.97494595937444,2.86441301530495,1.48682524070851,1.32884695706137,2.91740423561101,2.05273523392530,0.484158685761050,1.22251015213411,1.20555416606715,2.21739157816595,1.25122151807734,1.74288039299222,2.31147350081870,0.596597719143055,2.31973456697152,0.0929404258465491,2.68468079581270,1.64583247151544,2.70066724790059,2.11661199514678,2.43645333392818,0.938103976130283,2.27339605760917,2.50624701643521,1.13548954253275,1.54664759745246,0.192223622645763,0.135522424792471,1.71034637591275,1.03381398126744,2.52894689205034,0.560443990314310,1.57531849222570,0.818907203241226,0.790815137392180,0.631116892390987,1.95057390402715,2.81475316972035,1.59742724775517,0.269131679871264,2.84015597985164,1.62069764052199,0.629130499408043,0.447155741835569,1.72496929736471,1.85506528339443,2.32056007927383,2.95226288110714,1.31489637584948;3.35266979857068,3.35030049333700,3.47266582007128,3.70010008071748,2.28819323782488,2.97911672725284,3.96906214531787,2.70094592497922,2.45612885827464,2.34695576100691,3.16563942780556,3.69116423761959,2.62956851895121,2.36450922356373,3.15852804658780,2.48286982393156,2.67055262324453,3.71475594728123,3.75677073171107,3.42275238724644,3.69538986625245,3.02868203901228,3.33230086839577,2.19118710502819,3.41230950755016,2.37072218767095,3.77884667775335,2.46027626701011,2.70020572036216,2.32116541532708,3.73840485063082,2.72208887088303,3.49641006605582,3.90364920020476,3.07112915851517,2.72530328184510,3.60986246872685,2.39368056189439,2.23996967861470,2.39186356061038,2.08483683610995,3.77483669867327,2.87946267627565,3.00034939869689,2.72987378745623,3.03087527026284,2.77410589623242,2.49876457529162,3.67545357330394,2.69890842148381];
    vehicles =  [1.83535169429879,1.69391294951796,1.50707968116449,0.929448718934209;0.915801821892250,0.142746637737223,1.89349773244790,0.0629726579279706];
    servers =[0.469351622915418,1.40498058407499;7.32970869723155,7.21865795199743];
    plotCoordinates(vehicles, users, servers);%在二维坐标中画出用户、车辆和BS的初始位置
    allLocations = [servers,vehicles];% 将车辆和基站合并到一个矩阵中
    for userIndex = 1:Ns
            for locationIndex = 1:(numBS + numVehicles)
                location = allLocations(:, locationIndex);% 计算所有用户与所有车辆和基站的位置
                distanceToLocation(userIndex,locationIndex)  = calculateDistance(users(:, userIndex), location);% 计算所有用户与所有车辆和基站的位置
                %disp(['用户', num2str(userIndex), ' 与位置', num2str(locationIndex), ' 的距离: ', num2str(distanceToLocation)]);% 计算所有用户与所有车辆和基站的位置
                if locationIndex <= 2
                    ChannelGain(userIndex,locationIndex) = 1 / (distanceToLocation(userIndex,locationIndex) )^(-3);
                    avg_rate_userIndex_locationIndex(userIndex,locationIndex) = bandwidth * log2(1 + (power * ChannelGain(userIndex,locationIndex)) / noise);% 计算所有用户与基站的传输速率
                end
                if locationIndex > 2
                    if (users(1, userIndex) - allLocations(1, locationIndex)) >= 0 %表示车辆在用户的左侧，车辆向右行驶， 
                        d(userIndex,locationIndex - 2) = users(2, userIndex) - allLocations(2, locationIndex);
                        l(userIndex,locationIndex -2) = R ^ 2 -(d(userIndex,locationIndex -2)) ^ 2;
                        t0(userIndex,locationIndex - 2) = sqrt(l(userIndex,locationIndex - 2)) / v;
                        t_stay(userIndex,locationIndex - 2) = t0(userIndex,locationIndex - 2) + ( users(1, userIndex) - allLocations(1, locationIndex) ) / v;%计算车辆从初始位置计算在用户的最大范围
                    end 
                    if (users(1,userIndex) - allLocations(1, locationIndex)) < 0 %表示车辆在用户的右侧，车辆向右行驶
                        d(userIndex,locationIndex - 2) = users(2, userIndex) - allLocations(2, locationIndex);
                        l(userIndex,locationIndex - 2) = R ^ 2 -(d(userIndex,locationIndex - 2)) ^ 2;
                        t0(userIndex,locationIndex - 2) = sqrt(l(userIndex,locationIndex - 2)) / v;
                        t_stay(userIndex,locationIndex - 2) = t0(userIndex,locationIndex -2) - ( users(1, userIndex) - allLocations(1, locationIndex) ) / v;%计算车辆从初始位置计算在用户的最大范围时的时间
                    end
                    rate_userIndex_locationIndex = @(t) bandwidth * log2(1 + (power * 1 ./ (sqrt( (abs(users(1, userIndex) - ( allLocations(1, locationIndex) + v * t ))) .^ 2 + (users(2, userIndex) - allLocations(2, locationIndex)) .^ 2)).^(-3)) ./ noise);
                    integral_rate_userIndex_locationIndex(userIndex,locationIndex - 2) = integral(rate_userIndex_locationIndex, 0, t_stay(userIndex,locationIndex - 2));
                    avg_rate_userIndex_locationIndex(userIndex,locationIndex) = integral_rate_userIndex_locationIndex(userIndex,locationIndex - 2) / t_stay(userIndex,locationIndex - 2);% 计算所有用户与车辆的传输速率
                end   
            end
        end
    % Initialize convergence flag
    converged = false;
    iterations = 0;  
    % Generate the first expected utility
    overall_head = zeros(Ns,1);
    for userIndex = 1 : size(b,1)
        expected_utility(userIndex) = - utility_function(b(userIndex,:),userIndex,b,avg_rate_userIndex_locationIndex,power,numBS,numVehicles,params.kn,params.fj,params.f_j_R, params.T_j_tol, params.E_j_tol,params.F_j_V, params.cj,params.E_i_p,params.an);
        for locationIndex = 1:(numBS + numVehicles)
                if locationIndex <= numBS
                        O_userIndex_locationIndex(userIndex,locationIndex) = (b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex) + params.cj(userIndex,1) * b(userIndex,locationIndex) / params.f_j_R) / params.T_j_tol(userIndex) + ...
                   (power * b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)) / params.E_j_tol(userIndex);
                end 
                if locationIndex > numBS
                    Di_(locationIndex - 2)  = params.E_i_p(locationIndex - 2)  / 1e-3;  
                    if (sum(b(setdiff(1 : Ns, userIndex), locationIndex)) +  b(userIndex,locationIndex) ) / Di_(locationIndex - 2) >=1
                        O_userIndex_locationIndex(userIndex,locationIndex) = ((b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.T_j_tol(userIndex) + ...
                           power * b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.E_j_tol(userIndex)) + params.cj(userIndex,1) * b(userIndex,locationIndex) / params.fj(userIndex,1) / params.T_j_tol(userIndex) + ...
                           1e-16 * params.cj(userIndex,1) * b(userIndex,locationIndex) * (params.fj(userIndex,1))^2 / params.E_j_tol(userIndex));
                    else 
                        O_userIndex_locationIndex(userIndex,locationIndex) = ((b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex) + params.cj(userIndex,1) * b(userIndex,locationIndex) / ...
                           (( 1 - (sum(b(setdiff(1 : Ns, userIndex), locationIndex)) +  b(userIndex,locationIndex) )/ Di_(locationIndex - 2) ) * params.F_j_V(locationIndex - 2)))/ params.T_j_tol(userIndex) + ...
                           power * b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.E_j_tol(userIndex)) *  (1 - (sum(b(setdiff(1 : Ns, userIndex), locationIndex)) +  b(userIndex,locationIndex) )/ Di_(locationIndex - 2)) + ...
                           ((sum(b(setdiff(1 : Ns, userIndex), locationIndex)) +  b(userIndex,locationIndex) )/ Di_(locationIndex - 2)) * ((b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.T_j_tol(userIndex) + ...
                           power * b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.E_j_tol(userIndex)) + params.cj(userIndex,1) * b(userIndex,locationIndex) / params.fj(userIndex,1) / params.T_j_tol(userIndex) + ...
                           1e-16 * params.cj(userIndex,1) * b(userIndex,locationIndex) * (params.fj(userIndex,1))^2 / params.E_j_tol(userIndex));
                    end
                end
         end
         overall_head(userIndex) = sum(O_userIndex_locationIndex(userIndex,:));
    end
    overall_head_converging(iterations + 1) = sum(overall_head(:,1)) / Ns;
    expected_utility_converging(iterations + 1) = sum(expected_utility(:,1)) / Ns;
    
     iterations = iterations + 1;  
        for userIndex = 1:Ns
            for locationIndex = 1:(numBS + numVehicles)
                 if locationIndex > numBS
                    if sum ( b(:,locationIndex))/ Di_(locationIndex - 2) >= 1
                    equation = @(h)- 1 * params.kn(userIndex) *( h / avg_rate_userIndex_locationIndex(userIndex,locationIndex) / params.T_j_tol(userIndex) + ...
                    h * power / avg_rate_userIndex_locationIndex(userIndex,locationIndex) / params.E_j_tol(userIndex)).^ params.an(userIndex);  
                    else
                    equation = @(h)(params.cj(userIndex,1) * h / params.T_j_tol(userIndex) / params.fj(userIndex) + ...
                    1e-16 * params.cj(userIndex,1) * h * (params.fj(userIndex,1))^2  / params.E_j_tol(userIndex) - ...
                    ((h / avg_rate_userIndex_locationIndex(userIndex,locationIndex) + ...
                    params.cj(userIndex,1) * h / ( 1 - (sum ( b(setdiff(1 : Ns, userIndex), locationIndex)) + h) / Di_(locationIndex - 2) ) / params.F_j_V(locationIndex - 2)) / params.T_j_tol(userIndex) + ...
                    h * power / avg_rate_userIndex_locationIndex(userIndex,locationIndex) / params.E_j_tol(userIndex))) .^ params.an(userIndex) * ( 1 - ( sum ( b(setdiff(1 : Ns, userIndex), locationIndex)) + h) / Di_(locationIndex - 2) ) - ...
                    params.kn(userIndex) * ((sum ( b(setdiff(1 : Ns, userIndex), locationIndex)) + h) / Di_(locationIndex - 2)) * ( h / avg_rate_userIndex_locationIndex(userIndex,locationIndex) / params.T_j_tol(userIndex) + ...
                    h * power / avg_rate_userIndex_locationIndex(userIndex,locationIndex) / params.E_j_tol(userIndex)).^ params.an(userIndex);
                    end
                    % 进行二分法求解               
                    b_replaced_solution(userIndex,locationIndex - 2)  = binary_search(equation, 0,Di_(locationIndex - 2),1000);
                    % 结果
                    b_userIndex_locationIndex(userIndex,locationIndex - 2) = min(b_replaced_solution(userIndex,locationIndex - 2) ,params.Dj(userIndex));
                   % disp(['求解得到的 b_replaced(userIndex,locationIndex) 值为: ' num2str(b_replaced_solution)]);
                 end
            end   
        end
         random_user_order =  randperm(Ns);
        for userIndex = random_user_order       
            [b, expected_utility] = play_offloading_game(b,expected_utility,b_userIndex_locationIndex,userIndex,avg_rate_userIndex_locationIndex,power,numBS,numVehicles,params.kn,params.fj,params.f_j_R, params.T_j_tol, params.E_j_tol,params.F_j_V, params.cj,params.Dj,params.E_i_p,Di_,t_stay,params.an)
            for locationIndex = 1:(numBS + numVehicles)
                if locationIndex <= numBS
                    O_userIndex_locationIndex(userIndex,locationIndex) = (b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex) + params.cj(userIndex,1) * b(userIndex,locationIndex) / params.f_j_R) / params.T_j_tol(userIndex) + ...
                   (power * b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)) / params.E_j_tol(userIndex);
                end 
                if locationIndex > numBS
                    if (sum(b(setdiff(1 : Ns, userIndex), locationIndex)) +  b(userIndex,locationIndex) )/ Di_(locationIndex - 2) >=1
                        O_userIndex_locationIndex(userIndex,locationIndex) = ((b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.T_j_tol(userIndex) + ...
                           power * b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.E_j_tol(userIndex)) + params.cj(userIndex,1) * b(userIndex,locationIndex) / params.fj(userIndex,1) / params.T_j_tol(userIndex) + ...
                           1e-16 * params.cj(userIndex,1) * b(userIndex,locationIndex) * (params.fj(userIndex,1))^2 / params.E_j_tol(userIndex));
                    else 
                        O_userIndex_locationIndex(userIndex,locationIndex) = ((b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex) + params.cj(userIndex,1) * b(userIndex,locationIndex) / ...
                           (( 1 - (sum(b(setdiff(1 : Ns, userIndex), locationIndex)) +  b(userIndex,locationIndex) )/ Di_(locationIndex - 2) ) * params.F_j_V(locationIndex - 2)))/ params.T_j_tol(userIndex) + ...
                           power * b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.E_j_tol(userIndex)) *  (1 - (sum(b(setdiff(1 : Ns, userIndex), locationIndex)) +  b(userIndex,locationIndex) )/ Di_(locationIndex - 2)) + ...
                           ((sum(b(setdiff(1 : Ns, userIndex), locationIndex)) +  b(userIndex,locationIndex) )/ Di_(locationIndex - 2)) * ((b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.T_j_tol(userIndex) + ...
                           power * b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.E_j_tol(userIndex)) + params.cj(userIndex,1) * b(userIndex,locationIndex) / params.fj(userIndex,1) / params.T_j_tol(userIndex) + ...
                           1e-16 * params.cj(userIndex,1) * b(userIndex,locationIndex) * (params.fj(userIndex,1))^2 / params.E_j_tol(userIndex));
                    end
                end
            end
            overall_head(userIndex) = sum(O_userIndex_locationIndex(userIndex,:) );
        end
        overall_head_converging(iterations + 1) = sum(overall_head(:,1)) / Ns
        expected_utility_converging(iterations + 1)= sum(expected_utility(:,1)) / Ns
            if  sum(b(:,3))/ Di_(1)>=1
                Probability_converging = 1;
            else
                Probability_converging = sum(b(:,3))/ Di_(1);
            end
           save('RAND_expected_utility_converging.mat', 'expected_utility_converging');
           save('RAND_Probability_converging.mat', 'Probability_converging');
    
    %% 画图
    subplot(2, 2, 2);
    yyaxis left
    plot(0:1:iterations,overall_head_converging(1,:) ,'b*-','LineWidth',1);
    hold on;  % 保持图像，以便在同一图像中绘制下一个变量   
    ylabel('Overhead')

    yyaxis right
    plot(0:1:iterations,expected_utility_converging(:),'or-','LineWidth',1);
    hold on;  % 保持图像，以便在同一图像中绘制下一个变量

    ylabel('Satisfaction Uitility')
      % 添加标题和标签
    %title('用户的任务完成时间和消耗能耗与截止时延和最大能耗要求比较');
    xlabel('迭代次数');
    legend( 'Overhead','Satisfaction Utility'); % 根据你的实际情况修改数据标签
     % 显示网格
    grid on;
    hold off;  % 关闭图像保持，完成绘图

end

