 fig = figure;
    height = 300;
    width = 150;
    set(fig,'Position',[100,100,width,height])
    % 加载 .mat 文件
    load('Probability.mat','Probability1','Probability2','Probability3'); % 加载文件
    
    % 获取数据的数量

    Probability11 = vpa(double(Probability1),6);
    Probability22 = vpa(double(Probability2),6);
    Probability33 = vpa(double(Probability3),6);
    % 获取最后一个数据
    last_data_1 = Probability33; 
    last_data_2 = Probability22;
    last_data_3 = Probability11;
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
      xticklabels({'F_j^V '});
    ylim([0.178,0.179]);
    % 设置 Y 轴标签
%     ylabel('Probability of Failure');

    legend('Vehicle1','Vehicle2','Vehicle3');


    % 显示图形
