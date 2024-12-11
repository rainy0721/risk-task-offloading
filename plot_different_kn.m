function plot_different_kn(kns, b,PoF,expected_utility,overhead)
    colors = {'r', 'b','g','y'};
    suptitle = 'Average b and PoF';
     % 遍历每个矩阵
    for i = 1:3
        % 计算第三列的平均值
        column_3_average(i) = mean(b{i}(:, 3));
        PoF1(i) = PoF{i};
        expected_utility1(i) = mean(expected_utility{i});
        overhead1(i) = mean(overhead{i});
    end
    disp(column_3_average);   
    subplot(2,1,1);
    yyaxis left
    plot(kns, column_3_average, '-', 'LineWidth', 2, 'DisplayName', 'offloading data', 'Color', colors{1});
   
    hold on
    yyaxis right
    plot(kns, PoF1, '--', 'LineWidth', 2, 'DisplayName', 'PoF', 'Color', colors{2});
    legend('Avg offloading data','PoF');
    hold off
    subplot(2,1,2);
    plot(kns, expected_utility1, '-*', 'LineWidth', 2, 'DisplayName', 'expected_utility', 'Color', colors{3}); 
    yyaxis left
    legend('Expected Utility');
    yyaxis right
    plot(kns, overhead1, '--', 'LineWidth', 2, 'DisplayName', 'expected_utility', 'Color', colors{4}); 
    legend('Overhead');
end

