    fig = figure;
    height = 300;
    width = 170;
    set(fig,'Position',[100,100,width,height])
    % ���� .mat �ļ�
    load('vehicle.mat','vehicle1','vehicle2','vehicle3'); % �����ļ�
    
    % ��ȡ���ݵ�����
    num_data = numel(vehicle1); % ����ÿ�� .mat �ļ��е����ݱ����ڱ��� your_data ��

    % ��ȡ���һ������
    last_data_1 = vehicle1(num_data); 
    last_data_2 = vehicle3(num_data);
    last_data_3 = vehicle2(num_data);
%     x_data(1) = params.F_j_V(1);
%     x_data(2) = params.F_j_V(4);
%     x_data(3) = params.F_j_V(3);

    x_data = [0.5,1,1.5];
    % ���� 4��������״ͼ

      % ���Ƶ�һ�����ӣ�������Ϊ��ɫ
    bar(x_data(1), last_data_1,0.5, 'FaceColor', 'r');
    hold on; % ����ͼ��

    % ���Ƶڶ������ӣ�������Ϊ��ɫ
    bar(x_data(2), last_data_2, 0.5,'FaceColor', 'g');

    % ���Ƶ��������ӣ�������Ϊ��ɫ
    bar(x_data(3), last_data_3, 0.5, 'FaceColor', 'b');

    % ���� X ��̶�Ϊ x_data
     xticks(1);

%     % ���� X ��̶ȱ�ǩ
      xticklabels({'Time stay '});
     ylim([3.1342e7,3.1348e7]);
    % ���� Y ���ǩ
    ylabel('Total Offloaded Data');
%     xlabel('time stay');
    legend('Vehicle1','Vehicle2','Vehicle3');


    % ��ʾͼ��
