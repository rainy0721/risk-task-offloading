function [vehicles, users, servers] = initializeCoordinates(numVehicles, Ns, numBs)
    % ��ʼ�����������꣬���ȷֲ��ڵ�һ���޵ĺ�����[0, 3]��������[0, 1.5]
    vehicles = [rand(1, numVehicles) * 3; rand(1, numVehicles) * 2];
    
    % ��ʼ���û������꣬���ȷֲ��ں�����[0, 3]��������[1.5, 3]
    users = [rand(1, Ns) * 3; rand(1, Ns) * 2 + 2];
    
    % ��ʼ����վ�����꣬������[0, 3]��������[6, 9]
    servers = [rand(1, numBs) * 3; rand(1, numBs) * 3 + 6];
end
