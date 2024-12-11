function plotCoordinates(vehicles, users, servers)
    figure('Position', [100, 100, 800, 600]); % ����ͼ��λ�úʹ�С

    % ������
    scatter(vehicles(1, :), vehicles(2, :), 'ro', 'filled');
    hold on;

    % ���û�
    scatter(users(1, :), users(2, :), 'bx');
   
    % ����վ
    scatter(servers(1, :), servers(2, :), 'go', 'filled');

    % ����ͼ�ı�����������ǩ
    title('�������û��ͻ�վ��λ��');
    xlabel('������(KM)');
    ylabel('������(KM)');

    % ���ͼ��
    legend('����', '�û�', '��վ');

    % ��ʾ����
    grid on;

    % ���������᷶Χ
    axis([0 3 0 9]);

    hold off;
end
