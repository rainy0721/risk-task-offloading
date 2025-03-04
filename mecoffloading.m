% simulation.m
function results = mecoffloading(params)
    numVehicles = 4;%车辆数量   
    numBS = 2;%BS数量
    bandwidth = 5e6;%带宽
%     transmissionPower_dBm = 30;%用户传输功率
    noisePower_dBm = -114;
    R = 200;%车辆与用户的覆盖范围
    v = 25;%车辆的速度
    noise = 10^(noisePower_dBm/10) / 1000;
     % Initialize b 
    [b,b1] = initialize(numBS,numVehicles,params.Dj);
    expected_utility = zeros(params.N,1);
    [vehicles, users, servers] = initializeCoordinates(numVehicles, params.N, numBS);%初始化用户、车辆和BS的位置
%     users = [1.44937738980625,2.97494595937444,2.86441301530495,1.48682524070851,1.32884695706137,2.91740423561101,2.05273523392530,0.484158685761050,1.22251015213411,1.20555416606715,2.21739157816595,1.25122151807734,1.74288039299222,2.31147350081870,0.596597719143055,2.31973456697152,0.0929404258465491,2.68468079581270,1.64583247151544,2.70066724790059,2.11661199514678,2.43645333392818,0.938103976130283,2.27339605760917,2.50624701643521,1.13548954253275,1.54664759745246,0.192223622645763,0.135522424792471,1.71034637591275,1.03381398126744,2.52894689205034,0.560443990314310,1.57531849222570,0.818907203241226,0.790815137392180,0.631116892390987,1.95057390402715,2.81475316972035,1.59742724775517,0.269131679871264,2.84015597985164,1.62069764052199,0.629130499408043,0.447155741835569,1.72496929736471,1.85506528339443,2.32056007927383,2.95226288110714,1.31489637584948;3.35266979857068,3.35030049333700,3.47266582007128,3.70010008071748,2.28819323782488,2.97911672725284,3.96906214531787,2.70094592497922,2.45612885827464,2.34695576100691,3.16563942780556,3.69116423761959,2.62956851895121,2.36450922356373,3.15852804658780,2.48286982393156,2.67055262324453,3.71475594728123,3.75677073171107,3.42275238724644,3.69538986625245,3.02868203901228,3.33230086839577,2.19118710502819,3.41230950755016,2.37072218767095,3.77884667775335,2.46027626701011,2.70020572036216,2.32116541532708,3.73840485063082,2.72208887088303,3.49641006605582,3.90364920020476,3.07112915851517,2.72530328184510,3.60986246872685,2.39368056189439,2.23996967861470,2.39186356061038,2.08483683610995,3.77483669867327,2.87946267627565,3.00034939869689,2.72987378745623,3.03087527026284,2.77410589623242,2.49876457529162,3.67545357330394,2.69890842148381];
%     vehicles =  [1.83535169429879,1.69391294951796,1.50707968116449,0.929448718934209;0.915801821892250,0.142746637737223,1.89349773244790,0.0629726579279706];
%     servers =[0.469351622915418,1.40498058407499;7.32970869723155,7.21865795199743];
%     plotCoordinates(vehicles, users, servers);%在二维坐标中画出用户、车辆和BS的初始位置
    allLocations = [servers,vehicles];% 将车辆和基站合并到一个矩阵中
    for userIndex = 1:params.N
            for locationIndex = 1:(numBS + numVehicles)
                location = allLocations(:, locationIndex);% 计算所有用户与所有车辆和基站的位置
                distanceToLocation(userIndex,locationIndex)  = calculateDistance(users(:, userIndex), location);% 计算所有用户与所有车辆和基站的位置
                %disp(['用户', num2str(userIndex), ' 与位置', num2str(locationIndex), ' 的距离: ', num2str(distanceToLocation)]);% 计算所有用户与所有车辆和基站的位置
                power(userIndex,locationIndex) = (distanceToLocation(userIndex,locationIndex))^2 / R; 
                if locationIndex <= 2
                    ChannelGain(userIndex,locationIndex) = 1 / (distanceToLocation(userIndex,locationIndex) )^(3);
                    avg_rate_userIndex_locationIndex(userIndex,locationIndex) = bandwidth * log2(1 + (power(userIndex,locationIndex) * ChannelGain(userIndex,locationIndex)) / noise);% 计算所有用户与基站的传输速率
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
                    rate_userIndex_locationIndex = @(t) bandwidth * log2(1 + (power(userIndex,locationIndex) * 1 ./ (sqrt( (abs(users(1, userIndex) - ( allLocations(1, locationIndex) + v * t ))) .^ 2 + (users(2, userIndex) - allLocations(2, locationIndex)) .^ 2)).^(-3)) ./ noise);
                    integral_rate_userIndex_locationIndex(userIndex,locationIndex - 2) = integral(rate_userIndex_locationIndex, 0, t_stay(userIndex,locationIndex - 2));
                    avg_rate_userIndex_locationIndex(userIndex,locationIndex) = integral_rate_userIndex_locationIndex(userIndex,locationIndex - 2) / t_stay(userIndex,locationIndex - 2);% 计算所有用户与车辆的传输速率
                end   
            end
    end
    % Initialize convergence flag
    converged = false;
    iterations = 0;  
    % Generate the first expected utility
    overall_head = zeros(params.N,1);
    for userIndex = 1 : size(b,1)
        expected_utility(userIndex) = - utility_function(b(userIndex,:),userIndex,b,avg_rate_userIndex_locationIndex,power,numBS,numVehicles,params.kn,params.fj,params.f_j_R, params.T_j_tol, params.E_j_tol,params.F_j_V, params.cj,params.E_i_p,params.an,params.N);
        for locationIndex = 1:(numBS + numVehicles)
                if locationIndex <= numBS
                        O_userIndex_locationIndex(userIndex,locationIndex) = (b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex) + params.cj(userIndex,1) * b(userIndex,locationIndex) / params.f_j_R(locationIndex)) / params.T_j_tol(userIndex) + ...
                   (power(userIndex,locationIndex) * b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)) / params.E_j_tol(userIndex);
                end 
                if locationIndex > numBS
                    Di_(locationIndex - 2)  = params.E_i_p(locationIndex - 2)  / 1e-3;  
                    if (sum(b(setdiff(1 : params.N, userIndex), locationIndex)) +  b(userIndex,locationIndex) ) / Di_(locationIndex - 2) >=1
                        O_userIndex_locationIndex(userIndex,locationIndex) = ((b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.T_j_tol(userIndex) + ...
                           power(userIndex,locationIndex) * b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.E_j_tol(userIndex)) + params.cj(userIndex,1) * b(userIndex,locationIndex) / params.fj(userIndex,1) / params.T_j_tol(userIndex) + ...
                           1e-25 * params.cj(userIndex,1) * b(userIndex,locationIndex) * (params.fj(userIndex,1))^2 / params.E_j_tol(userIndex));
                    else 
                        O_userIndex_locationIndex(userIndex,locationIndex) = ((b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex) + params.cj(userIndex,1) * b(userIndex,locationIndex) / ...
                           (( 1 - (sum(b(setdiff(1 : params.N, userIndex), locationIndex)) +  b(userIndex,locationIndex) )/ Di_(locationIndex - 2) ) * params.F_j_V(locationIndex - 2)))/ params.T_j_tol(userIndex) + ...
                           power(userIndex,locationIndex) * b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.E_j_tol(userIndex)) *  (1 - (sum(b(setdiff(1 : params.N, userIndex), locationIndex)) +  b(userIndex,locationIndex) )/ Di_(locationIndex - 2)) + ...
                           ((sum(b(setdiff(1 : params.N, userIndex), locationIndex)) +  b(userIndex,locationIndex) )/ Di_(locationIndex - 2)) * ((b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.T_j_tol(userIndex) + ...
                           power(userIndex,locationIndex) * b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.E_j_tol(userIndex)) + params.cj(userIndex,1) * b(userIndex,locationIndex) / params.fj(userIndex,1) / params.T_j_tol(userIndex) + ...
                           1e-25 * params.cj(userIndex,1) * b(userIndex,locationIndex) * (params.fj(userIndex,1))^2 / params.E_j_tol(userIndex));
                    end
                end
         end
         overall_head(userIndex) = sum(O_userIndex_locationIndex(userIndex,:));
    end
            c2 = 0;
            c5 = 0;
            c6 = 0;
            c9 = 0;
          for j = 1:(numBS + numVehicles)
                    if j <= numBS
                        c1(j) = b(1,j)  / avg_rate_userIndex_locationIndex( 1,j ) + b(1,j) * params.cj(1,1) / params.f_j_R(j);
                        c2 = c2 + c1(j);
                        c8(j) =  b(1,j) / avg_rate_userIndex_locationIndex(1,j) * power(1,j) ;
                        c9 = c9+ c8(j);
                    end
                    if j > numBS
                        if sum(b(:,j)) / Di_(j - 2) >=1
                            c3(j-2) = b(1,j) / avg_rate_userIndex_locationIndex( 1,j ) + params.cj(1,1) / params.fj(1,1) *  b(1,j);
                            c4(j-2) = 1e-25 * params.cj(1,1) * (params.fj(1,1))^ 2 *  b(1,j);
                            c5 = c5 + c3(j-2);
                            c6 = c6+ c4(j-2);
                            c8(j) =  b(1,j) / avg_rate_userIndex_locationIndex(1,j) * power(1,j) ;
                            c9 = c9+ c8(j);
                        else
                            c3(j-2) = b(1,j) / avg_rate_userIndex_locationIndex( 1,j ) + b(1,j) * params.cj(1,1) / params.F_j_V(j-2) + ...
                            params.cj(1,1) / params.fj(1,1) * ( b(1,j)^2 / Di_(j-2) + b(1,j) * ( sum ( b(setdiff(1 :params.N, 1), j))) / Di_(j-2));
                            c4(j-2) = 1e-25 * params.cj(1,1) * (params.fj(1,1))^ 2 *  b(1,j) * ( b(1,j) + sum ( b(setdiff(1 :params.N, 1), j))) / Di_(j-2);
                            c5 = c5 + c3(j-2);
                            c6 = c6+ c4(j-2);
                            c8(j) =  b(1,j) / avg_rate_userIndex_locationIndex(1,j) * power(1,j) ;
                            c9 = c9+ c8(j); 
                        end
                    end
          end
    c7(iterations + 1) = c2+ c5
    c10(iterations + 1) = c9 + c6 
    bs1(iterations+1) = sum(b(:,1));
    bs2(iterations+1)= sum(b(:,2));
    vehicle1(iterations+1) = sum(b(:,3))
    vehicle2(iterations+1) = sum(b(:,4))
    vehicle3(iterations+1) = sum(b(:,5))
    vehicle4(iterations+1) = sum(b(:,6))
    overall_head_converging(iterations + 1) = sum(overall_head(:,1)) / params.N;
    expected_utility_converging(iterations + 1) = sum(expected_utility(:,1)) / params.N;
    disp('进入循环:');
    while ~converged
        iterations = iterations + 1;
        flag = 0;
        disp(['当前迭代次数: ' num2str(iterations)]);
        for userIndex = 1  : params.N
            for locationIndex = 1:(numBS + numVehicles)
                 if locationIndex > numBS
                    if sum ( b(:,locationIndex))/ Di_(locationIndex - 2) >= 1
                    equation = @(h)- 1 * params.kn(userIndex) *( h / avg_rate_userIndex_locationIndex(userIndex,locationIndex) / params.T_j_tol(userIndex) + ...
                    h * power(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex) / params.E_j_tol(userIndex)).^ params.an(userIndex);  
                    else
                    equation = @(h)(params.cj(userIndex,1) * h / params.T_j_tol(userIndex) / params.fj(userIndex) + ...
                    1e-25 * params.cj(userIndex,1) * h * (params.fj(userIndex,1))^2  / params.E_j_tol(userIndex) - ...
                    ((h / avg_rate_userIndex_locationIndex(userIndex,locationIndex) + ...
                    params.cj(userIndex,1) * h / ( 1 - (sum ( b(setdiff(1 : params.N, userIndex), locationIndex)) + h) / Di_(locationIndex - 2) ) / params.F_j_V(locationIndex - 2)) / params.T_j_tol(userIndex) + ...
                    h * power(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex) / params.E_j_tol(userIndex))) .^ params.an(userIndex) * ( 1 - ( sum ( b(setdiff(1 : params.N, userIndex), locationIndex)) + h) / Di_(locationIndex - 2) ) - ...
                    params.kn(userIndex) * ((sum ( b(setdiff(1 : params.N, userIndex), locationIndex)) + h) / Di_(locationIndex - 2)) * ( h / avg_rate_userIndex_locationIndex(userIndex,locationIndex) / params.T_j_tol(userIndex) + ...
                    h * power(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex) / params.E_j_tol(userIndex)).^ params.an(userIndex);
                    end
                    % 进行二分法求解               
                    b_replaced_solution(userIndex,locationIndex - 2)  = binary_search(equation, 0,Di_(locationIndex - 2),1000);
                    % 结果
                    b_userIndex_locationIndex(userIndex,locationIndex - 2) = min(b_replaced_solution(userIndex,locationIndex - 2) ,params.Dj(userIndex));
                   % disp(['求解得到的 b_replaced(userIndex,locationIndex) 值为: ' num2str(b_replaced_solution)]);
                 end
            end   
        end
         random_user_order =  randperm(params.N);
        for userIndex =  random_user_order  
            b_old = b;
            %disp('b_old:');
            %disp(b_old);
            [b, expected_utility] = play_offloading_game(b,expected_utility,b_userIndex_locationIndex,userIndex,avg_rate_userIndex_locationIndex,power,numBS,numVehicles,params.kn,params.fj,params.f_j_R, params.T_j_tol, params.E_j_tol,params.F_j_V, params.cj,params.Dj,params.E_i_p,Di_,t_stay,params.an,params.N)
%             b_old1 = b1;
%             %disp('b_old:');
%             %disp(b_old);
%             [b1,expected_utility1] = play_offloading_game1(b1,expected_utility1,b_userIndex_locationIndex,userIndex,avg_rate_userIndex_locationIndex,power,numBS,numVehicles,params.kn,params.fj,params.f_j_R, params.T_j_tol, params.E_j_tol,params.F_j_V, params.cj,params.Dj,params.E_i_p,Di_,t_stay,params.an);
%             % Check if the game has reached a Nash equilibrium
%             flag1 = game_converged(b1(userIndex,:), b_old1(userIndex,:),flag,params.e1)    
            for locationIndex = 1:(numBS + numVehicles)
                if locationIndex <= numBS
                    O_userIndex_locationIndex(userIndex,locationIndex) = (b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex) + params.cj(userIndex,1) * b(userIndex,locationIndex) / params.f_j_R(locationIndex)) / params.T_j_tol(userIndex) + ...
                   (power(userIndex,locationIndex) * b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)) / params.E_j_tol(userIndex);
                end 
                if locationIndex > numBS
                    if (sum(b(setdiff(1 : params.N, userIndex), locationIndex)) +  b(userIndex,locationIndex) )/ Di_(locationIndex - 2) >=1
                        O_userIndex_locationIndex(userIndex,locationIndex) = ((b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.T_j_tol(userIndex) + ...
                           power(userIndex,locationIndex) * b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.E_j_tol(userIndex)) + params.cj(userIndex,1) * b(userIndex,locationIndex) / params.fj(userIndex,1) / params.T_j_tol(userIndex) + ...
                           1e-25 * params.cj(userIndex,1) * b(userIndex,locationIndex) * (params.fj(userIndex,1))^2 / params.E_j_tol(userIndex));
                    else 
                        O_userIndex_locationIndex(userIndex,locationIndex) = ((b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex) + params.cj(userIndex,1) * b(userIndex,locationIndex) / ...
                           (( 1 - (sum(b(setdiff(1 : params.N, userIndex), locationIndex)) +  b(userIndex,locationIndex) )/ Di_(locationIndex - 2) ) * params.F_j_V(locationIndex - 2)))/ params.T_j_tol(userIndex) + ...
                           power(userIndex,locationIndex) * b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.E_j_tol(userIndex)) *  (1 - (sum(b(setdiff(1 : params.N, userIndex), locationIndex)) +  b(userIndex,locationIndex) )/ Di_(locationIndex - 2)) + ...
                           ((sum(b(setdiff(1 : params.N, userIndex), locationIndex)) +  b(userIndex,locationIndex) )/ Di_(locationIndex - 2)) * ((b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.T_j_tol(userIndex) + ...
                           power(userIndex,locationIndex) * b(userIndex,locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ params.E_j_tol(userIndex)) + params.cj(userIndex,1) * b(userIndex,locationIndex) / params.fj(userIndex,1) / params.T_j_tol(userIndex) + ...
                           1e-25 * params.cj(userIndex,1) * b(userIndex,locationIndex) * (params.fj(userIndex,1))^2 / params.E_j_tol(userIndex));
                    end
                end
            end
            overall_head(userIndex) = sum(O_userIndex_locationIndex(userIndex,:) );
            % Check if the game has reached a Nash equilibrium
            flag = game_converged(b(userIndex,:), b_old(userIndex,:),flag,params.e1)      
        end
        overall_head_converging(iterations + 1) = sum(overall_head(:,1)) / params.N
        expected_utility_converging(iterations + 1)= sum(expected_utility(:,1)) / params.N
        bs1(iterations+1) = sum(b(:,1));
        bs2(iterations+1)= sum(b(:,2));
        vehicle1(iterations+1) = sum(b(:,3));
        vehicle2(iterations+1) = sum(b(:,4));
        vehicle3(iterations+1) = sum(b(:,5));
        vehicle4(iterations+1) = sum(b(:,6));
        if flag == params.N 
           converged = 1;
           Probability_converging =vpa ((sum(b(:,3))/ Di_(1) + sum(b(:,4))/ Di_(2) + sum(b(:,5))/ Di_(3) + sum(b(:,6))/ Di_(4))) / 4;
           Probability1 =  vpa(sum(b(:,3))/ Di_(1),8);
           Probability2 =  vpa(sum(b(:,4))/ Di_(2));
           Probability3 =  vpa(sum(b(:,5))/ Di_(3));
           Probability4 =  vpa(sum(b(:,6))/ Di_(4));
%            distance1_rsu = sum(distanceToLocation(:,1)) / params.N
%            distance2_rsu = sum(distanceToLocation(:,2)) / params.N
            t_stay_avg1 = sum(t_stay(:,1)) / params.N
            t_stay_avg2 = sum(t_stay(:,2)) / params.N
            t_stay_avg3 = sum(t_stay(:,3)) / params.N
            t_stay_avg4 = sum(t_stay(:,4)) / params.N
%            distance1 = sum(distanceToLocation(48,:))/6
%            distance2 = sum(distanceToLocation(49,:))/6
%            distance3 = sum(distanceToLocation(50,:))/6
%            save('PT_expected_utility_converging.mat', 'expected_utility_converging');
%            save('PT_Probability_converging.mat', 'Probability_converging');
%            save('vehicle.mat', 'vehicle1','vehicle2','vehicle3','vehicle4');
%            save('Probability.mat', 'Probability1','Probability2','Probability3','Probability4');
%            save('RSU.mat','bs1','bs2')
           save('E0.1.mat', 'expected_utility_converging','v')
           disp(['当前迭代次数: ' num2str(iterations)]);  
        end
            c2 = 0;
            c5 = 0;
            c6 = 0;
            c9 = 0;
            c1 = 0;
            c3 = 0;
            c4 = 0;
            c8 = 0;
          for j = 1:(numBS + numVehicles)
                    if j <= numBS
                        c1(j) = b(1,j)  / avg_rate_userIndex_locationIndex( 1,j ) + b(1,j) * params.cj(1,1) / params.f_j_R(j);
                        c2 = c2 + c1(j);
                        c8(j) =  b(1,j) / avg_rate_userIndex_locationIndex(1,j) * power(1,j) ;
                        c9 = c9+ c8(j);
                    end
                    if j > numBS
                         if sum(b(:,j)) / Di_(j - 2) >=1
                            c3(j-2) = b(1,j) / avg_rate_userIndex_locationIndex( 1,j ) + params.cj(1,1) / params.fj(1,1) *  b(1,j);
                            c4(j-2) = 1e-25 * params.cj(1,1) * (params.fj(1,1))^ 2 *  b(1,j);
                            c5 = c5 + c3(j-2);
                            c6 = c6+ c4(j-2);
                            c8(j) =  b(1,j) / avg_rate_userIndex_locationIndex(1,j) * power(1,j) ;
                            c9 = c9+ c8(j);
                         else
                            c3(j-2) = b(1,j) / avg_rate_userIndex_locationIndex( 1,j ) + b(1,j) * params.cj(1,1) / params.F_j_V(j-2) + ...
                            params.cj(1,1) / params.fj(1,1) * ( b(1,j)^2 / Di_(j-2) + b(1,j) * ( sum ( b(setdiff(1 :params.N, 1), j))) / Di_(j-2));
                            c4(j-2) = 1e-25 * params.cj(1,1) * (params.fj(1,1))^ 2 *  b(1,j) * ( b(1,j) + sum ( b(setdiff(1 :params.N, 1), j))) / Di_(j-2);
                            c5 = c5 + c3(j-2);
                            c6 = c6+ c4(j-2);
                            c8(j) =  b(1,j) / avg_rate_userIndex_locationIndex(1,j) * power(1,j);
                            c9 = c9+ c8(j);
                         end
                    end
          end
        c7(iterations + 1) = c2+ c5
        c10(iterations + 1) = c9 + c6 
         disp(Di_);
    end
     % Store results in a struct
     results.params = params;
     results.vehicles = vehicles;
     results.users = users;
     results.servers = servers;
     results.b = b;
     results.expected_utility = expected_utility;
     results.Probability_converging = Probability_converging;
     results.overall_head = overall_head;
    %% 画图1
    subplot(2, 2, 1);
    yyaxis left
    plot(0:1:iterations,c7*1000,'b*-','LineWidth',1);
    hold on;  % 保持图像，以便在同一图像中绘制下一个变量   
    
    plot(0:1:iterations,params.T_j_tol(1:iterations + 1)*1000,'bs--','LineWidth',1);
    hold on;  % 保持图像，以便在同一图像中绘制下一个变量

    ylabel('Time (msec)')
    yyaxis right
    plot(0:1:iterations,c10,'or-');
    hold on;  % 保持图像，以便在同一图像中绘制下一个变量
    
    plot(0:1:iterations,params.E_j_tol(1:iterations + 1),'rp--','LineWidth',1);
    hold on;  % 保持图像，以便在同一图像中绘制下一个变量

    ylabel('Energy(J)')
      % 添加标题和标签
    %title('用户的任务完成时间和消耗能耗与截止时延和最大能耗要求比较');
    xlabel('迭代次数');
    % 显示网格
    grid on;
    legend( 'Expected Time Overhead','Time Deadline for User','Expected Energy Overhead','Energy Availability'); % 根据你的实际情况修改数据标签
    hold off;  % 关闭图像保持，完成绘图
    %% 画图2
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

    %% 画图3
    subplot(2, 2, 3);
     % 绘制迭代数据
    plot(0:1:iterations, bs1(1, :),'b*-');
    hold on;  % 保持图像，以便在同一图像中绘制下一个变量
   

    % 绘制迭代数据
    plot(0:1:iterations, bs2(1, :),'og-');
    hold on;  % 保持图像，以便在同一图像中绘制下一个变量


    % 绘制迭代数据
    plot(0:1:iterations, vehicle1(1, :),'ob-');
    hold on;  % 保持图像，以便在同一图像中绘制下一个变量


    % 绘制迭代数据
    plot(0:1:iterations, vehicle2(1,:),'ys-');
    hold on;  % 保持图像，以便在同一图像中绘制下一个变量


    % 绘制迭代数据
    plot(0:1:iterations, vehicle3(1,:),'kp-');
    hold on;  % 保持图像，以便在同一图像中绘制下一个变量


    % 绘制迭代数据
    plot(0:1:iterations, vehicle4(1,:),'r*-');
    hold on;  % 保持图像，以便在同一图像中绘制下一个变量
     % 添加标题和标签
    title('卸载到各个服务器的数据随着迭代次数的变化');
    xlabel('迭代次数');
    ylabel('卸载数据');
    legend('BS1', 'BS2', 'vehicles1', 'vehicles2','vehicles3','vehicles4'); % 根据你的实际情况修改数据标签
     % 显示网格
    grid on;
    hold off;  % 关闭图像保持，完成绘图
    

end

