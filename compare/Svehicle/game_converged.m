function flag = game_converged(b, b_old,flag, e1)
    % Check if the game has converged

    % e1 is the error tolerance defined in parameters
    if all(abs(b - b_old) < e1)
        flag = flag + 1;
    else
        flag = flag + 0;
    end
end
