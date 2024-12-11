function [b,b1] = initialize(numBS,numVehicles, Dj)
    % Initialize probabilities for the simulation
    S = numBS + numVehicles;
    b =  Dj * [1/3,1/3,1/3];
    b1 =  Dj * [1/6,1/6,1/6,1/6,1/6,1/6];
end




