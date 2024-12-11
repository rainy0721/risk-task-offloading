function [b, expected_utility] = play_offloading_game(b,expected_utility,b_userIndex_locationIndex,i,avg_rate_userIndex_locationIndex,power,numBS,numVehicles,k,fj,f_j_R, T_j_tol, E_j_tol,F_j_V,cj,Dj,E_i_p,Di_,t_stay,a)
    % Play the offloading game
        b_new = zeros(size(b));
        Ns = 50;
        % find best response of each one based on utility
        A = [ ];
        be  = [ ];
        Aeq =[1,1,1];
        beq = Dj(i);
        lb  = [0,0,0];
        ub = [ Dj(i),Dj(i),b_userIndex_locationIndex(i,1)];
        for user = 1 : Ns
            for server= 1 : 3
                total(user,server) = sum ( b(setdiff(1 :Ns, user), server));
            end
        end
        options = optimoptions('fmincon','Display','iter');
        b0 = [Dj(i)/4,Dj(i)/4,Dj(i)/2];
        funfcn = @(x)utility_function(x, i, b, avg_rate_userIndex_locationIndex, power, numBS, numVehicles,k,fj,f_j_R,T_j_tol,E_j_tol,F_j_V, cj,E_i_p,a);
        [b_new(i,:),expected_utility_new,exitflag,output] = fmincon(funfcn,b0,A,be,Aeq,beq,lb,ub,@(x)nonlinear(x,i,avg_rate_userIndex_locationIndex,f_j_R,cj,F_j_V,fj,Di_,T_j_tol,E_j_tol,total,t_stay,power,b),options)
        expected_utility(i) = -expected_utility_new;
        b(i,:) = b_new(i,:);
end



