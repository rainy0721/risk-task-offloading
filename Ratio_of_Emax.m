figure; % 创建一个新的图形窗口

colors = ['r', 'm', 'c','g', 'b']; % 定义用于绘制折线图的颜色

file_names = {'E0.1.mat','E0.2.mat', 'E0.3.mat', 'E0.4.mat',  'E0.5.mat'}; % 定义所有 .mat 文件的文件名

x_values = []; % 初始化 x_values 数组
all_last_data = []; % 初始化所有最后一个数据的数组

for i = 1:numel(file_names)
    % 加载 .mat 文件
    load(file_names{i}); % 加载文件
    
    % 获取数据的数量
    num_data = numel(expected_utility_converging); % 假设每个 .mat 文件中的数据保存在变量 your_data 中

    % 获取最后一个数据
    last_data = expected_utility_converging(num_data); % 获取最后一个数据

    x_values(end+1) = 10 + (i - 1) * 10; % 添加 x 值到数组
    
    all_last_data(end+1) = last_data; % 添加最后一个数据到数组
end

% 绘制折线图
plot(x_values, all_last_data, '-o'); % 绘制折线图，并将数据点标记为圆形
grid on
ylabel('Avg Satisfaction Utility '); % Y 轴标签
xlabel('Ratio of Emax to the full energy of the vehicle(%)')
ylim([0.5,2.5])
set(gca, 'XTick', x_values); % 设置横坐标刻度为提供的 x_values