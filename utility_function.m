function [ u ] = utility_function(x, userIndex, b, avg_rate_userIndex_locationIndex, power, numBS, numVehicles,k,fj,f_j_R,T_j_tol,E_j_tol,F_j_V, cj,E_i_p,a,N)
    % Utility function for the offloading game
    %计算的是第i个用户的效用
    % replace user's i offloading value
    b_replaced = b;
    %此时x是一个向量
    for locationIndex = 1:(numBS + numVehicles)
        if locationIndex <= numBS
            T_Communication_userIndex_locationIndex(userIndex,locationIndex) = x(locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex);
            E_userIndex_locationIndex(userIndex,locationIndex) = T_Communication_userIndex_locationIndex(userIndex,locationIndex) * power;
            T_Compute_userIndex_locationIndex(userIndex,locationIndex) = cj(userIndex,1) * x(locationIndex) / f_j_R;
            O_userIndex_locationIndex(userIndex,locationIndex) = ( x(locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex) + cj(userIndex,1) * x(locationIndex) / f_j_R) / T_j_tol(userIndex) + ...
               (power * x(locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)) / E_j_tol(userIndex);
        end
        if locationIndex > numBS
           T_Communication_userIndex_locationIndex(userIndex,locationIndex) = x(locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex);
           E_userIndex_locationIndex(userIndex,locationIndex) = T_Communication_userIndex_locationIndex(userIndex,locationIndex) * power;
           Di_(locationIndex - 2)  = E_i_p(locationIndex - 2)  / 1e-3;
           f_j_v(locationIndex - 2) = ( 1 - (sum(b_replaced(setdiff(1 : N, userIndex), locationIndex)) +  x(locationIndex) )/ Di_(locationIndex - 2) ) * F_j_V(locationIndex - 2);
           T_Compute_userIndex_locationIndex(userIndex,locationIndex) = cj(userIndex,1) * x(locationIndex) / f_j_v(locationIndex - 2);                      
           if sum(b_replaced(:,locationIndex)) / Di_(locationIndex - 2) >=1
               O_userIndex_locationIndex(userIndex,locationIndex) = ((x(locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ T_j_tol(userIndex) + ...
                   power * x(locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ E_j_tol(userIndex)) + cj(userIndex,1) * x(locationIndex) / fj(userIndex,1) / T_j_tol(userIndex) + 1e-16 * cj(userIndex,1) * x(locationIndex) * (fj(userIndex,1))^2 / E_j_tol(userIndex));
           else
               O_userIndex_locationIndex(userIndex,locationIndex) = ((x(locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex) + cj(userIndex,1) * x(locationIndex) / ...
                   (( 1 - (sum(b_replaced(setdiff(1 : N, userIndex), locationIndex)) +  x(locationIndex) )/ Di_(locationIndex - 2) ) * F_j_V(locationIndex - 2)))/ T_j_tol(userIndex) + ...
                   power * x(locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ E_j_tol(userIndex)) *  (1 - (sum(b_replaced(setdiff(1 : N, userIndex), locationIndex)) +  x(locationIndex) )/ Di_(locationIndex - 2)) + ...
                   ((sum(b_replaced(setdiff(1 : N, userIndex), locationIndex)) +  x(locationIndex) )/ Di_(locationIndex - 2)) * ((x(locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ T_j_tol(userIndex) + ...
                   power * x(locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ E_j_tol(userIndex)) + cj(userIndex,1) * x(locationIndex) / fj(userIndex,1) / T_j_tol(userIndex) + 1e-16 * cj(userIndex,1) * x(locationIndex) * (fj(userIndex,1))^2 / E_j_tol(userIndex));
           end
           if sum(b_replaced(:,locationIndex) )/ Di_(locationIndex - 2) >=1
               E_PT_userIndex_locationIndex(userIndex,locationIndex - 2) = -1*k(userIndex) * ( x(locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ T_j_tol(userIndex) + ...
                   x(locationIndex) * power / avg_rate_userIndex_locationIndex(userIndex,locationIndex) / E_j_tol(userIndex)) .^ a(userIndex); 
           else 
               E_PT_userIndex_locationIndex(userIndex,locationIndex - 2) = (cj(userIndex,1) * x(locationIndex)/ T_j_tol(userIndex) / fj(userIndex) + ...
                   1e-16 * cj(userIndex,1) * x(locationIndex) * (fj(userIndex,1))^2 / E_j_tol(userIndex) - ...
                   ((x(locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex) + ...
                   cj(userIndex,1) * x(locationIndex) / (( 1 - (sum(b_replaced(setdiff(1 : N, userIndex), locationIndex)) +  x(locationIndex) )/ Di_(locationIndex - 2) ) * F_j_V(locationIndex - 2))) / T_j_tol(userIndex) + ...
                   x(locationIndex) * power / avg_rate_userIndex_locationIndex(userIndex,locationIndex) / E_j_tol(userIndex))) .^ a(userIndex) * ( 1 - ( (sum ( b_replaced(setdiff(1 : N, userIndex), locationIndex)) +  x(locationIndex)) / Di_(locationIndex - 2) )) - ...
                   k(userIndex) * ((sum ( b_replaced(setdiff(1 : N, userIndex), locationIndex) ) +  x(locationIndex)) / Di_(locationIndex - 2))  * ( x(locationIndex) / avg_rate_userIndex_locationIndex(userIndex,locationIndex)/ T_j_tol(userIndex) + ...
                   x(locationIndex) * power / avg_rate_userIndex_locationIndex(userIndex,locationIndex) / E_j_tol(userIndex)) .^ a(userIndex); 
           end
        end   
    end
    overall_head = sum( O_userIndex_locationIndex(userIndex,:) );
    expected_utility = sum( E_PT_userIndex_locationIndex(userIndex,:)) - sum( O_userIndex_locationIndex(userIndex,1:numBS) );

    % return minus the utility because we want to use minimization
    % optimization, even though we want to maximize the utility
    u = -expected_utility;
end

