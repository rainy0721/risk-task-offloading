
    % ���� .mat �ļ�
    load('vehicle.mat','vehicle1','vehicle2','vehicle3'); % �����ļ�
    
    % ��ȡ���ݵ�����
    num_data = numel(vehicle1); % ����ÿ�� .mat �ļ��е����ݱ����ڱ��� your_data ��

    % ��ȡ���һ������
    last_data_1 = vehicle3(num_data); 
    last_data_2 = vehicle2(num_data);
    last_data_3 = vehicle1(num_data);
%     x_data(1) = params.F_j_V(1);
%     x_data(2) = params.F_j_V(4);
%     x_data(3) = params.F_j_V(3);
    x_data = 1:3;
    % ���� 4��������״ͼ
    figure; % ����һ���µ�ͼ�δ���
      % ���Ƶ�һ�����ӣ�������Ϊ��ɫ
    bar(x_data(1), last_data_1, 'FaceColor', 'r');
    hold on; % ����ͼ��

    % ���Ƶڶ������ӣ�������Ϊ��ɫ
    bar(x_data(2), last_data_2, 'FaceColor', 'g');

    % ���Ƶ��������ӣ�������Ϊ��ɫ
    bar(x_data(3), last_data_3, 'FaceColor', 'b');

    % ���� X ��̶�Ϊ x_data
     xticks(x_data);

    % ���� X ��̶ȱ�ǩ
     xticklabels({'d_i^3', 'd_i^2', 'd_i^1'});

    % ���� Y ���ǩ
    ylabel('Total Offloaded Data');
    xlabel('d_i');
    legend('Vehicle3','Vehicle2','Vehicle1');


    % ��ʾͼ��
