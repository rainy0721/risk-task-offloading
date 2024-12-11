function [vehicles, users, servers] = initializeCoordinates(numVehicles, Ns, numBs)
    % 初始化车辆的坐标，均匀分布在第一象限的横坐标[0, 3]，纵坐标[0, 1.5]
    vehicles = [rand(1, numVehicles) * 3; rand(1, numVehicles) * 2];
    
    % 初始化用户的坐标，均匀分布在横坐标[0, 3]，纵坐标[1.5, 3]
    users = [rand(1, Ns) * 3; rand(1, Ns) * 2 + 2];
    
    % 初始化基站的坐标，横坐标[0, 3]，纵坐标[6, 9]
    servers = [rand(1, numBs) * 3; rand(1, numBs) * 3 + 6];
end
