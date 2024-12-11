figure; % ����һ���µ�ͼ�δ���

colors = ['r', 'g', 'b', 'm', 'c']; % �������ڻ�����״ͼ����ɫ

file_names = {'PT_expected_utility_converging.mat', 'Svehicle_expected_utility_converging.mat', 'RAND_expected_utility_converging.mat', 'nonProsTheor_expected_utility_converging.mat', 'GOFF_expected_utility_converging.mat'}; % �������� .mat �ļ����ļ���

% ������״ͼ�Ŀ��
bar_width = 0.5; % �ɸ�����Ҫ������״ͼ�Ŀ��

for i = 1:numel(file_names)
    % ���� .mat �ļ�
    load(file_names{i}); % �����ļ�
    
    % ��ȡ���ݵ�����
    num_data = numel(expected_utility_converging); % ����ÿ�� .mat �ļ��е����ݱ����ڱ��� your_data ��

    % ��ȡ���һ������
    last_data = expected_utility_converging(num_data); % ��ȡ���һ������

    % ��ȡҪ���Ƶ�����
    % ����Ҫ���Ƶ����ݱ����ڽṹ���ֶ� last_data.height ��
    heights = last_data; % ���� height ��Ҫ���Ƶ�����

    % ���� x ��λ��
    x_values = (1:numel(heights)) + (i - 1) * (numel(heights) + 1) * bar_width;

    % ������״ͼ
    color_index = mod(i, numel(colors)) + 1; % ����ѭ������ѡ����ɫ
    bar(x_values, heights, bar_width, colors(color_index)); % ������״ͼ����ѡ����ɫ
    hold on; % ����ͼ�Σ��Ա���ͬһͼ�ϻ��ƶ����״ͼ
end


ylabel('Avg Satisfaction Utility '); % Y ���ǩ

% ���� x ��̶�
xticks(1:numel(heights) + (numel(heights) + 1) * (numel(file_names) - 1) * bar_width); % ���� x ��̶�
xticklabels({'PT', 'Single vehicle', 'RandomPartial', 'NonPT', 'Fulloff'}); % ���� x ��̶ȱ�ǩ��������Ҫ�޸�
xtickangle(45); % ��ת x ��̶ȱ�ǩ

legend('PT', 'Single vehicle', 'RandomPartial', 'NonPT', 'Fulloff'); % ���ͼ��
hold off; % �ر� hold on ģʽ���Ա�����ͼ�ϻ�����������

