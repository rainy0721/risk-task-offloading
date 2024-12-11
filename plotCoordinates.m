function plotCoordinates(vehicles, users, servers)
    figure('Position', [100, 100, 800, 600]); % 设置图的位置和大小

    % 画车辆
    scatter(vehicles(1, :), vehicles(2, :), 'ro', 'filled');
    hold on;

    % 画用户
    scatter(users(1, :), users(2, :), 'bx');
   
    % 画基站
    scatter(servers(1, :), servers(2, :), 'go', 'filled');

    % 设置图的标题和坐标轴标签
    title('车辆、用户和基站的位置');
    xlabel('横坐标(KM)');
    ylabel('纵坐标(KM)');

    % 添加图例
    legend('车辆', '用户', '基站');

    % 显示网格
    grid on;

    % 设置坐标轴范围
    axis([0 3 0 9]);

    hold off;
end
