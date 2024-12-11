function [b, expected_utility] = play_offloading_game(b,expected_utility,b_userIndex_locationIndex,i,avg_rate_userIndex_locationIndex,power,numBS,numVehicles,k,fj,f_j_R, T_j_tol, E_j_tol,F_j_V,cj,Dj,E_i_p,Di_,t_stay,a)
    % Play the offloading game
        b_new = zeros(size(b));
        Ns = 50;
        for user = 1 : Ns
            for server= 1 : 6
                total(user,server) = sum ( b(setdiff(1 :Ns, user), server));
            end
        end
        x = rand(1,6) / sum(rand(1,6)) * Dj(i);
        %funf = utility_function(b0, i, b, avg_rate_userIndex_locationIndex, power, numBS, numVehicles,k,fj,f_j_R,T_j_tol,E_j_tol,F_j_V, cj,E_i_p,a)
        expected_utility_new = utility_function(x, i, b, avg_rate_userIndex_locationIndex, power, numBS, numVehicles,k,fj,f_j_R,T_j_tol,E_j_tol,F_j_V, cj,E_i_p,a);
        %options = optimoptions('fmincon', 'Algorithm', 'interior-point', 'MaxIterations', 1000, 'TolX', 1e-6);
        %[b_new(i,:), expected_utility_new,exitflag,output] = fmincon(funfcn,b0,A,be,Aeq,beq,lb,ub, @(b)nonlinear(b,i,avg_rate_userIndex_locationIndex,f_j_R,cj,F_j_V,fj,Di_,T_j_tol,E_j_tol,total,t_stay,power),options)
   
        expected_utility(i) = -expected_utility_new;
        b(i,:) = x;
end



