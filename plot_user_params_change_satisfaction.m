    fig = figure;
    height = 400;
    width = 800;
    set(fig,'Position',[100,100,width,height])
    % 获取最后一个数据
    last_data_1 = results.expected_utility(1); 
    last_data_2 = results.expected_utility(2);
    last_data_3 = results.expected_utility(3);
    
    last_data_4 = results.expected_utility(7);
    last_data_5 = results.expected_utility(8);
    last_data_6 = results.expected_utility(9);
    
    last_data_7 = results.expected_utility(10);
    last_data_8 = results.expected_utility(11);
    last_data_9 = results.expected_utility(12);
    
    last_data_10 = results.expected_utility(13);
    last_data_11 = results.expected_utility(14);
    last_data_12 = results.expected_utility(15);
    
    last_data_13 = results.expected_utility(16);
    last_data_14 = results.expected_utility(17);
    last_data_15 = results.expected_utility(18);

    
    last_data_16 = results.expected_utility(50);
    last_data_17 = results.expected_utility(48);
    last_data_18 = results.expected_utility(49);

     x_data = [0.2,0.7,1.2,2,2.5,3,3.8,4.3,4.8,5.6,6.1,6.6,7.4,7.9,8.4,9.2,9.7,10.2];
     
      % 绘制第一个柱子，并设置为红色
    bar(x_data(1), last_data_1,0.5, 'FaceColor', 'r');
    hold on; % 保持图形
    grid on;
    % 绘制第二个柱子，并设置为绿色
    bar(x_data(2), last_data_2, 0.5,'FaceColor', 'g');
    hold on; % 保持图形
    grid on;
    % 绘制第三个柱子，并设置为蓝色
    bar(x_data(3), last_data_3, 0.5,'FaceColor', 'b');
    hold on; 
    
      grid on;
    bar(x_data(4), last_data_4,0.5, 'FaceColor', 'r');
    hold on; % 保持图形

    % 绘制第二个柱子，并设置为绿色
    bar(x_data(5), last_data_5, 0.5,'FaceColor', 'g');
    hold on; % 保持图形

    % 绘制第三个柱子，并设置为蓝色
    bar(x_data(6), last_data_6, 0.5,'FaceColor', 'b');
    hold on; 
    
    bar(x_data(7), last_data_7,0.5, 'FaceColor', 'r');
    hold on; % 保持图形

    % 绘制第二个柱子，并设置为绿色
    bar(x_data(8), last_data_8, 0.5,'FaceColor', 'g');
    hold on; % 保持图形

    % 绘制第三个柱子，并设置为蓝色
    bar(x_data(9), last_data_9, 0.5,'FaceColor', 'b');
    hold on; 
    
    bar(x_data(10), last_data_10,0.5, 'FaceColor', 'r');
    hold on; % 保持图形

    % 绘制第二个柱子，并设置为绿色
    bar(x_data(11), last_data_11, 0.5,'FaceColor', 'g');
    hold on; % 保持图形

    % 绘制第三个柱子，并设置为蓝色
    bar(x_data(12), last_data_12, 0.5,'FaceColor', 'b');
    hold on; 
    
    bar(x_data(13), last_data_13,0.5, 'FaceColor', 'r');
    hold on; % 保持图形

    % 绘制第二个柱子，并设置为绿色
    bar(x_data(14), last_data_14, 0.5,'FaceColor', 'g');
    hold on; % 保持图形

    % 绘制第三个柱子，并设置为蓝色
    bar(x_data(15), last_data_15, 0.5,'FaceColor', 'b');
    hold on; 
    
    bar(x_data(16), last_data_16,0.5, 'FaceColor', 'r');
    hold on; % 保持图形

    % 绘制第二个柱子，并设置为绿色
    bar(x_data(17), last_data_17, 0.5,'FaceColor', 'g');
    hold on; % 保持图形

    % 绘制第三个柱子，并设置为蓝色
    bar(x_data(18), last_data_18, 0.5,'FaceColor', 'b');
    hold on; 
    % 设置 X 轴刻度标签
    xticks([0.7,2.5,4.3,6.1,7.9,9.7]);
    xticklabels({'f_j ', ' k_n', 'T_j^t ', ' E_j^t', 'a_n ', 'd_i '});
    ylabel('Satisfaction Utility');
    ylim([1.9,2.9]);


    % 显示图形
