    fig = figure;
    height = 300;
    width = 170;
    set(fig,'Position',[100,100,width,height])
    % 加载 .mat 文件
    load('vehicle.mat','vehicle1','vehicle2','vehicle3'); % 加载文件
    
    % 获取数据的数量
    num_data = numel(vehicle1); % 假设每个 .mat 文件中的数据保存在变量 your_data 中

    % 获取最后一个数据
    last_data_1 = vehicle1(num_data); 
    last_data_2 = vehicle3(num_data);
    last_data_3 = vehicle2(num_data);
%     x_data(1) = params.F_j_V(1);
%     x_data(2) = params.F_j_V(4);
%     x_data(3) = params.F_j_V(3);

    x_data = [0.5,1,1.5];
    % 步骤 4：绘制柱状图

      % 绘制第一个柱子，并设置为红色
    bar(x_data(1), last_data_1,0.5, 'FaceColor', 'r');
    hold on; % 保持图形

    % 绘制第二个柱子，并设置为绿色
    bar(x_data(2), last_data_2, 0.5,'FaceColor', 'g');

    % 绘制第三个柱子，并设置为蓝色
    bar(x_data(3), last_data_3, 0.5, 'FaceColor', 'b');

    % 设置 X 轴刻度为 x_data
     xticks(1);

%     % 设置 X 轴刻度标签
      xticklabels({'Time stay '});
     ylim([3.1342e7,3.1348e7]);
    % 设置 Y 轴标签
    ylabel('Total Offloaded Data');
%     xlabel('time stay');
    legend('Vehicle1','Vehicle2','Vehicle3');


    % 显示图形
