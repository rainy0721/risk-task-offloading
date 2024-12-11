function plot_different_an(an_s, b,PoF,expected_utility)
    colors = {'r', 'b','g'};

    suptitle = 'Average b and PoF';
    
    column_3_average = zeros(1, 3);

    % 遍历每个矩阵
    for i = 1:3
        % 计算第三列的平均值
        column_3_average(i) = mean(b{i}(:, 3));
        PoF1(i) = PoF{i};
        expected_utility1(i) = mean(expected_utility{i});
    end

    disp(column_3_average);
    subplot(2,1,1);
    yyaxis left
    plot( an_s, column_3_average, '-', 'LineWidth', 2, 'DisplayName', 'offloading data', 'Color', colors{1});
    hold on
    yyaxis right
    plot(an_s, PoF1, '--', 'LineWidth', 2, 'DisplayName', 'PoF', 'Color', colors{2});
    legend('Avg offloading data','PoF');
    subplot(2,1,2);
     plot(an_s, expected_utility1, '-*', 'LineWidth', 2, 'DisplayName', 'expected_utility', 'Color', colors{3}); 
    legend('Expected Utility');
    hold off
end

