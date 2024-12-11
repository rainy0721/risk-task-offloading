 fig = figure;
    height = 300;
    width = 150;
    set(fig,'Position',[100,100,width,height])
    % 加载 .mat 文件
    load('RSU.mat','bs1','bs2'); % 加载文件
    
    % 获取数据的数量
    num_data = numel(bs1); % 假设每个 .mat 文件中的数据保存在变量 your_data 中

    % 获取最后一个数据
    last_data_1 = bs1(num_data); 
    last_data_2 = bs2(num_data);
      x_data = [0.5,1];
    % 步骤 4：绘制柱状
      % 绘制第一个柱子，并设置为红色
    bar(x_data(1), last_data_1, 0.5,'FaceColor', 'r');
    hold on; % 保持图形

    % 绘制第二个柱子，并设置为绿色
    bar(x_data(2), last_data_2,0.5, 'FaceColor', 'g');

    % 设置 X 轴刻度为 x_data
     xticks(0.75);

    % 设置 X 轴刻度标签
     xticklabels({'d_j '});
        ylim([1.717e8,1.7185e8])
%      ylabel('Total Offloaded Data');
    legend('SBS1','SBS2');


    % 显示图形
