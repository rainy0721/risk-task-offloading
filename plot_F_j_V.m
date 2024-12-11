
    % 加载 .mat 文件
    load('vehicle.mat','vehicle1','vehicle3','vehicle4'); % 加载文件
    
    % 获取数据的数量
    num_data = numel(vehicle1); % 假设每个 .mat 文件中的数据保存在变量 your_data 中

    % 获取最后一个数据
    last_data_1 = vehicle1(num_data); 
    last_data_2 = vehicle4(num_data);
    last_data_3 = vehicle3(num_data);
%     x_data(1) = params.F_j_V(1);
%     x_data(2) = params.F_j_V(4);
%     x_data(3) = params.F_j_V(3);
    x_data = 1:3;
    % 步骤 4：绘制柱状图
    figure; % 创建一个新的图形窗口
      % 绘制第一个柱子，并设置为红色
    bar(x_data(1), last_data_1, 'FaceColor', 'r');
    hold on; % 保持图形

    % 绘制第二个柱子，并设置为绿色
    bar(x_data(2), last_data_2, 'FaceColor', 'g');

    % 绘制第三个柱子，并设置为蓝色
    bar(x_data(3), last_data_3, 'FaceColor', 'b');

    % 设置 X 轴刻度为 x_data
     xticks(x_data);

    % 设置 X 轴刻度标签
     xticklabels({'F_j^V1', 'F_j^V4', ' F_j^V3'});

    % 设置 Y 轴标签
    ylabel('Total Offloaded Data');
    xlabel('F_j_V');
    legend('Vehicle1','Vehicle4','Vehicle3');


    % 显示图形
