function [b] = initialize(numBS,numVehicles,Dj)
    % Initialize probabilities for the simulation
    S = numBS + numVehicles;
    b =  Dj * [0,0,1,0,0,0];
end




