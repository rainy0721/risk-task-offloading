function [b, expected_utility] = play_offloading_game(b,expected_utility,b_userIndex_locationIndex,i,avg_rate_userIndex_locationIndex,power,numBS,numVehicles,k,fj,f_j_R, T_j_tol, E_j_tol,F_j_V,cj,Dj,E_i_p,Di_,t_stay,a,N)
    % Play the offloading game
        b_new = zeros(size(b));
        % find best response of each one based on utility
        A = [ ];
        be  = [ ];
        Aeq =[1,1,1,1,1,1];
        beq = Dj(i);
        lb  = [0,0,0,0,0,0];
        ub = [ Dj(i),Dj(i),b_userIndex_locationIndex(i,1),b_userIndex_locationIndex(i,2),b_userIndex_locationIndex(i,3),b_userIndex_locationIndex(i,4)];
        for user = 1 : N
            for server= 1 : 6
                total(user,server) = sum ( b(setdiff(1 :N, user), server));
            end
        end
        options = optimoptions('fmincon','Display','iter');
        b0 = [Dj(i)/6,Dj(i)/6,Dj(i)/6,Dj(i)/6,Dj(i)/6,Dj(i)/6];
        %funf = utility_function(b0, i, b, avg_rate_userIndex_locationIndex, power, numBS, numVehicles,k,fj,f_j_R,T_j_tol,E_j_tol,F_j_V, cj,E_i_p,a)
        funfcn = @(x)utility_function(x, i, b, avg_rate_userIndex_locationIndex, power, numBS, numVehicles,k,fj,f_j_R,T_j_tol,E_j_tol,F_j_V, cj,E_i_p,a,N);
        %options = optimoptions('fmincon', 'Algorithm', 'interior-point', 'MaxIterations', 1000, 'TolX', 1e-6);
        %[b_new(i,:), expected_utility_new,exitflag,output] = fmincon(funfcn,b0,A,be,Aeq,beq,lb,ub, @(b)nonlinear(b,i,avg_rate_userIndex_locationIndex,f_j_R,cj,F_j_V,fj,Di_,T_j_tol,E_j_tol,total,t_stay,power),options)
        [b_new(i,:),expected_utility_new,exitflag,output] = fmincon(funfcn,b0,A,be,Aeq,beq,lb,ub,@(x)nonlinear(x,i,avg_rate_userIndex_locationIndex,f_j_R,cj,F_j_V,fj,Di_,T_j_tol,E_j_tol,total,t_stay,power,b),options)
        expected_utility(i) = -expected_utility_new;
        b(i,:) = b_new(i,:);
end



