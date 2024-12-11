figure; % 创建一个新的图形窗口

colors = ['r', 'm', 'c','g', 'b']; % 定义用于绘制柱状图的颜色

file_names = {'PT_Probability_converging.mat', 'Svehicle_Probability_converging.mat', 'RAND_Probability_converging.mat',  'GOFF_Probability_converging.mat'}; % 定义所有 .mat 文件的文件名

% 定义柱状图的宽度
bar_width = 0.5; % 可根据需要调整柱状图的宽度
% 加载 .mat 文件
    load(file_names{1}); % 加载文件

    % 获取最后一个数据
    last_data =  0.1689; % 获取最后一个数据

    % 获取要绘制的数据
    % 假设要绘制的数据保存在结构体字段 last_data.height 中
    heights = last_data; % 假设 height 是要绘制的数据

    % 计算 x 轴位置
    x_values = (1:numel(heights)) + (1 - 1) * (numel(heights) + 1) * bar_width;

    % 绘制柱状图
    color_index = mod(1, numel(colors)) + 1; % 根据循环索引选择颜色
    bar(x_values, heights, bar_width, colors(color_index)); % 绘制柱状图，并选择颜色
    hold on; % 保持图形，以便在同一图上绘制多个柱状图
for i = 2:numel(file_names)
    % 加载 .mat 文件
    load(file_names{i}); % 加载文件
    
   

    % 获取最后一个数据
    last_data = Probability_converging; % 获取最后一个数据

    % 获取要绘制的数据
    % 假设要绘制的数据保存在结构体字段 last_data.height 中
    heights = last_data; % 假设 height 是要绘制的数据

    % 计算 x 轴位置
    x_values = (1:numel(heights)) + (i - 1) * (numel(heights) + 1) * bar_width;

    % 绘制柱状图
    color_index = mod(i, numel(colors)) + 1; % 根据循环索引选择颜色
    bar(x_values, heights, bar_width, colors(color_index)); % 绘制柱状图，并选择颜色
    hold on; % 保持图形，以便在同一图上绘制多个柱状图
end


ylabel('Avg Probability of Failure '); % Y 轴标签

% 设置 x 轴刻度
xticks(1:numel(heights) + (numel(heights) + 1) * (numel(file_names) - 1) * bar_width); % 设置 x 轴刻度
xticklabels({'PT', 'Single vehicle', 'RandomPartial',  'Fulloff'}); % 设置 x 轴刻度标签，根据需要修改
xtickangle(45); % 旋转 x 轴刻度标签

legend('PT', 'Single vehicle', 'RandomPartial','Fulloff'); % 添加图例
hold off; % 关闭 hold on 模式，以便在新图上绘制其他内容

